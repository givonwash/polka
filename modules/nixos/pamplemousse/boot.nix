{ config, pkgs, lib, ... }:

let
  inherit (lib) mkDefault;
in
{
  boot = {
    # Enable Lanzaboote for Secure Boot
    lanzaboote = {
      enable = true;
      # Use sbctl for key management (creates keys in /etc/secureboot)
      pkiBundle = "/etc/secureboot";
    };

    # Disable systemd-boot (replaced by lanzaboote)
    loader.systemd-boot.enable = lib.mkForce false;
    loader.efi.canTouchEfiVariables = true;

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
        # LUKS support
        "dm_mod"
        "dm_crypt"
        "cryptd"
        "aesni_intel"
        "sha256"
        "sha512"
      ];
      kernelModules = [ ];

      # LUKS configuration for root device unlock
      luks.devices."cryptroot" = {
        device = "/dev/disk/by-partlabel/cryptroot";
        allowDiscards = true;  # TRIM support for SSDs
        # Optional: key file for automatic unlock (if you want to use a keyfile later)
        # keyFile = "/keyfile";
        # fallbackToPassword = true;
      };
    };

    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

    # Hibernation support: resume from swap file on encrypted root
    # The offset will be determined after creating the swap file
    # To calculate: sudo filefrag -v /swapfile | head -20
    # Look for "first_extents" and note the physical offset
    # Then set: resume_offset = <physical offset>
    # For now, we'll set up the configuration to be completed post-install
    resumeDevice = "/dev/mapper/cryptroot";
  };

  # Required for sbctl key generation
  environment.systemPackages = with pkgs; [
    sbctl
  ];
}
