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
      graphics.enable = true;
    };

  networking = {
    networkmanager.enable = true;
    useDHCP = false;
    interfaces.wlp0s20f3.useDHCP = true;
  };

  # Hibernation resume is configured in boot.nix via boot.resumeDevice
  # The resume offset will be set via boot.kernelParams after installation
  # To calculate offset: sudo filefrag -v /swapfile | head -20
  # Then add to kernelParams: "resume_offset=<physical_offset>"
  powerManagement.cpuFreqGovernor = mkDefault "powersave";
}
