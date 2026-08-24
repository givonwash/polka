{
  self,
  lib,
  home-manager,
  mediator,
  omp,
  cliPkgs,
  combyPkgs,
  nix-darwin,
  mac-app-util,
  aarch64-darwin,
  utilityModules,
  ...
}:
let
  system = aarch64-darwin;
  cpkgs = import cliPkgs {
    inherit system;
    config.allowUnfree = true;
  };
in
nix-darwin.lib.darwinSystem {
  inherit system;
  lib = lib;
  modules = [
    mac-app-util.darwinModules.default
    home-manager.darwinModules.default
    utilityModules.nix
    utilityModules.nixpkgs
    self.darwinModules.guanabana
    self.darwinModules.givon
    self.homeModules.givon
    (
      { pkgs, ... }:
      {
        _.guanabana.homebrew.enable = false;
        home-manager.sharedModules = [
          mac-app-util.homeManagerModules.default
        ];
        _.givon = {
          # Frequently-updated CLI tools (cloud + modern dev)
          frequentCliTools = with cpkgs; [
            awscli2
            (callPackage ../pkgs/av.nix { })
            claude-code
            codex
            devbox
            gh
            google-cloud-sdk
            graphite-cli
            (callPackage ../pkgs/meticulous-cli { })
            (callPackage ../pkgs/ntn.nix { })
            omp.packages.${system}.default
            opencode
            tuicr
          ];
          # Stable tools
          stableCliTools = with pkgs; [
            ast-grep
            combyPkgs.legacyPackages.${system}.comby
            go
            imagemagick
            pandoc
            shfmt
            mediator.packages.${system}.default
            (snowflake-cli.override {
              python3Packages = python3Packages.override {
                overrides = self: super: {
                  snowflake-connector-python = super.snowflake-connector-python.overridePythonAttrs (old: {
                    propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++
                      (old.optional-dependencies.secure-local-storage or [ ]);
                  });
                };
              };
            })
          ];
          git = {
            enable = true;
            wt = {
              enable = true;
              package = cpkgs.git-wt;
            };
            email = "gwashington@makenotion.com";
            userName = "Givon Washington";
          };
          homebrew.enable = false;
          theme = {
            colors = import ../modules/home/givon/colors/catppuccin.nix;
            fonts = {
              defaultSize = 15;
              defaultScalingFactor = 1.1;
              emoji = {
                name = "Apple Color Emoji";
                package = null;
              };
            };
          };
          shell = {
            enable = true;
            pyenv.enable = true;
            tfenv.enable = true;
          };
          wezterm = {
            enable = true;
            enableInstallation = false;
            enableHomebrewInstallation = false;
            appearance.fontSize = 17.5;
          };
          ghostty = {
            enable = true;
            enableInstallation = false;
            appearance.fontSize = 17.5;
          };
          stateVersion = "23.11";
          userConfig = {
            name = "gwashington";
            home = "/Users/gwashington";
          };
        };
      }
    )
  ];
}
