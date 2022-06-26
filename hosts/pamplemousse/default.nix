{ config, lib, modulesPath, pkgs, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
      kernelModules = [ ];
    };
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  documentation.man = {
    generateCaches = true;
    man-db.enable = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
  };

  environment.systemPackages = with pkgs; [ git vim ];

  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    bluetooth.enable = true;
    opengl.enable = true;
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 30d";
  };

  networking = {
    networkmanager.enable = true;
    useDHCP = false;
    interfaces = {
      wlp0s20f3.useDHCP = true;
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  security.rtkit.enable = true;

  services = {
    pipewire = {
      alsa = {
        enable = true;
        support32Bit = true;
      };
      enable = true;
      pulse.enable = true;
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-label/swap"; }
  ];

  systemd.user.services.pipewire-pulse.path = [ pkgs.pulseaudio ];

  time.timeZone = "US/Pacific";
}
