{ config, lib, modulesPath, pkgs, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./audio.nix
    ./boot.nix
    ./environment.nix
    ./filesystem.nix
    ./hardware.nix
    ./security.nix
  ];
}
