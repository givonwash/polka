{
  lib,
  buildNpmPackage,
  makeWrapper,
  nodejs,
}:

# `@alwaysmeticulous/cli` ships only to npm (no lockfile in the published
# tarball), so `package.json`/`package-lock.json` here are a generated wrapper
# that pins the CLI and its transitive deps. To bump:
#   1. set the version in package.json (both places) and below
#   2. npm install --package-lock-only --ignore-scripts
#   3. nix run nixpkgs#prefetch-npm-deps -- package-lock.json
buildNpmPackage {
  pname = "meticulous-cli";
  version = "2.318.0";

  src = ./.;

  npmDepsHash = "sha256-Z0AfCSHY1w0yEIIrnUFDYJczc0gLmaG22oOd7qOMGK8=";

  # Nothing to compile; the published package is prebuilt JS.
  dontNpmBuild = true;
  npmFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r node_modules $out/lib/node_modules

    makeWrapper ${lib.getExe nodejs} $out/bin/meticulous \
      --add-flags $out/lib/node_modules/@alwaysmeticulous/cli/dist/main.js

    runHook postInstall
  '';

  meta = {
    description = "CLI for Meticulous, a visual regression testing service";
    homepage = "https://github.com/alwaysmeticulous/meticulous-sdk";
    license = lib.licenses.isc;
    mainProgram = "meticulous";
    platforms = lib.platforms.unix;
  };
}
