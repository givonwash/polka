{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.21.8";

  # The `ntn` npm package bundles a prebuilt, self-contained executable per
  # platform under dist/<dir>/ntn. Pick the one matching the host.
  dir =
    {
      "aarch64-darwin" = "ntn-darwin-arm64";
      "x86_64-darwin" = "ntn-darwin-x64";
      "aarch64-linux" = "ntn-linux-arm64";
      "x86_64-linux" = "ntn-linux-x64";
    }
    .${stdenvNoCC.hostPlatform.system}
      or (throw "ntn: unsupported system ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation {
  pname = "ntn";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/ntn/-/ntn-${version}.tgz";
    hash = "sha256-GwZvZaXg5RfUtZPnWzCyLscHlmYyeph4OBzyPYyjvIM=";
  };

  # macOS binaries run as-is; Linux ELF binaries need their interpreter patched.
  nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [ autoPatchelfHook ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 dist/${dir}/ntn $out/bin/ntn
    runHook postInstall
  '';

  meta = {
    description = "Official Notion CLI";
    homepage = "https://developers.notion.com/cli";
    license = lib.licenses.mit;
    mainProgram = "ntn";
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
