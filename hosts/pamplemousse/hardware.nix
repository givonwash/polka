{ config, lib, ... }:

let
  inherit (lib) mkDefault;
in
{
  hardware =
    let
      cfg = config.hardware;
    in
    {
      cpu.intel.updateMicrocode = mkDefault cfg.enableRedistributableFirmware;
      bluetooth.enable = true;
      opengl.enable = true;
    };

  networking = {
    networkmanager.enable = true;
    useDHCP = false;
    interfaces.wlp0s20f3.useDHCP = true;
  };

  powerManagement.cpuFreqGovernor = mkDefault "powersave";
}
