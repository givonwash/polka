{
  lib,
  bun,
  makeWrapper,
  omp,
  runCommand,
}:

# nixpkgs ships `omp` as a launcher around its own Bun runtime, but plugin
# commands shell out to a bare `bun` resolved from $PATH. Prepend Bun's bin
# directory to the launcher's PATH instead of exposing Bun to the shell.
runCommand "omp-${omp.version}" {
  nativeBuildInputs = [ makeWrapper ];
  meta = omp.meta;
} ''
  makeWrapper ${lib.getExe omp} $out/bin/omp --prefix PATH : ${lib.makeBinPath [ bun ]}
''
