{ lib, ... }:

{
  hardware.graphics.enable = true;

  networking = {
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };
}
