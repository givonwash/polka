{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "17.2.10";

  # Upstream ships a single self-contained (Bun-compiled) executable per
  # platform as a release asset. Pick the one matching the host.
  #
  # Hashes come from the release's SHA256SUMS.txt, converted to SRI.
  asset =
    {
      "aarch64-darwin" = {
        name = "omp-darwin-arm64";
        hash = "sha256-43+j1NPusVtx1bRk/eUfkT45CXikjcM7TFJ7ju1yN8Y=";
      };
      "x86_64-darwin" = {
        name = "omp-darwin-x64";
        hash = "sha256-IGR/4Zqy5HRRZVXbXIE/XZrv/FVuRWzfnuiQB8ipi+8=";
      };
      "aarch64-linux" = {
        name = "omp-linux-arm64";
        hash = "sha256-yTXV0l62d6Ylk0+B9LIbD/BbZEAP656Q8C8O/jlnY4Y=";
      };
      "x86_64-linux" = {
        name = "omp-linux-x64";
        hash = "sha256-T+VksjSCzWJ2caJBeEJJjJey9ytfijpO+4CU5iPfejM=";
      };
    }
    .${stdenvNoCC.hostPlatform.system}
      or (throw "omp: unsupported system ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation {
  pname = "omp";
  inherit version;

  src = fetchurl {
    url = "https://github.com/can1357/oh-my-pi/releases/download/v${version}/${asset.name}";
    inherit (asset) hash;
  };

  # The asset is a bare executable, not an archive.
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  # macOS binaries run as-is; Linux ELF binaries need their interpreter patched.
  nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/omp
    runHook postInstall
  '';

  meta = {
    description = "AI coding agent for the terminal";
    homepage = "https://github.com/can1357/oh-my-pi";
    license = lib.licenses.mit;
    mainProgram = "omp";
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
