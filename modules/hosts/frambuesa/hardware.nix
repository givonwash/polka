{ lib, ... }:

{
  hardware.opengl.enable = true;

  networking = {
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };
}
