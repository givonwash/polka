{ config, lib, ... }:

{
  hardware =
    let
      cfg = config.hardware;
    in
    {
      cpu.intel.updateMicrocode = lib.mkDefault cfg.enableRedistributableFirmware;
      bluetooth.enable = true;
      opengl.enable = true;
    };

  networking = {
    networkmanager.enable = true;
    useDHCP = false;
    interfaces.wlp0s20f3.useDHCP = true;
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
