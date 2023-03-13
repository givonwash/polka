{ config, lib, modulesPath, pkgs, ... }:

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
  ];
}
