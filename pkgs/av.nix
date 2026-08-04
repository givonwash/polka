{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "av";
  version = "0.1.45";

  src = fetchFromGitHub {
    owner = "aviator-co";
    repo = "av";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ndB4kLLNHtp0WcBmGw4J+WD0eU4X3AtzThM/KXiaVZE=";
  };

  vendorHash = "sha256-ay7MKobJaLTE9pQQubimDoyIjMi184CU3P6wMhQkGbQ=";

  subPackages = [ "cmd/av" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/aviator-co/av/internal/config.Version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd av \
      --bash <($out/bin/av completion bash) \
      --fish <($out/bin/av completion fish) \
      --zsh <($out/bin/av completion zsh)
  '';

  meta = {
    description = "CLI to manage stacked pull requests";
    homepage = "https://github.com/aviator-co/av";
    license = lib.licenses.mit;
    mainProgram = "av";
    platforms = lib.platforms.unix;
  };
})
