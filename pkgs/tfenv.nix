{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  bash,
  curl,
  unzip,
  gnugrep,
  gnused,
  gawk,
  coreutils,
}:

stdenv.mkDerivation rec {
  pname = "tfenv";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "tfutils";
    repo = "tfenv";
    rev = "v${version}";
    hash = "sha256-2Fpaj/UQDE7PNFX9GNr4tygvKmm/X0yWVVerJ+Y6eks=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -r bin lib libexec share $out/

    for f in $out/bin/* $out/libexec/*; do
      if [ -f "$f" ] && head -1 "$f" | grep -q '^#!'; then
        wrapProgram "$f" \
          --prefix PATH : ${lib.makeBinPath [
            bash
            curl
            unzip
            gnugrep
            gnused
            gawk
            coreutils
          ]}
      fi
    done
  '';

  meta = with lib; {
    description = "Terraform version manager";
    homepage = "https://github.com/tfutils/tfenv";
    license = licenses.mit;
  };
}
