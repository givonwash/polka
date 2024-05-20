{ modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./audio.nix
    ./boot.nix
    ./environment.nix
    ./filesystem.nix
    ./gdm.nix
    ./gnome.nix
    ./hardware.nix
    ./security.nix
    ./sway.nix
    ./virtualisation.nix
    ./xdg.nix
  ];

  config = {
    networking.hostName = "frambuesa";
    system.stateVersion = "23.11";
  };
}
