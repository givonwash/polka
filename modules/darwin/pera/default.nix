{
  imports = [
    ./homebrew.nix
  ];
  config = {
    services.nix-daemon.enable = true;
    system.stateVersion = 4;
  };
}
