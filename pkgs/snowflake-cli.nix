{ callPackage, fetchFromGitHub, nixpkgsPath, python313Packages, }:
let
  pythonPackages = python313Packages.override {
    overrides = final: prev: {
      click = prev.click.overridePythonAttrs (_: {
        version = "8.1.8";
        src = fetchFromGitHub {
          owner = "pallets";
          repo = "click";
          tag = "8.1.8";
          hash = "sha256-pAAqf8jZbDfVZUoltwIFpov/1ys6HSYMyw3WV2qcE/M=";
        };
      });
      typer = prev.typer.overridePythonAttrs (_: {
        version = "0.17.3";
        src = fetchFromGitHub {
          owner = "fastapi";
          repo = "typer";
          tag = "0.17.3";
          hash = "sha256-ir4RL1Cdq0ENr0ojiJvrdFaZHb4bF8q4rLcKeowliR0=";
        };
        dependencies =
          [ final.click final.typing-extensions final.rich final.shellingham ];
      });
      snowflake-connector-python =
        prev.snowflake-connector-python.overridePythonAttrs (old: {
          propagatedBuildInputs = (old.propagatedBuildInputs or [ ])
            ++ (old.optional-dependencies.secure-local-storage or [ ]);
        });
    };
  };
  # Snowflake CLI 3.13.1 supports Python through 3.13 and pins these releases.
in callPackage (nixpkgsPath + "/pkgs/by-name/sn/snowflake-cli/package.nix") {
  python3Packages = pythonPackages;
}
