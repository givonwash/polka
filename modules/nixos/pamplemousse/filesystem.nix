{ config, pkgs, ... }:

{
  fileSystems = {
    # Encrypted root filesystem using device mapper name from boot.initrd.luks.devices
    "/" = {
      device = "/dev/mapper/cryptroot";
      fsType = "ext4";
      options = [ "noatime" "discard" ];  # SSD optimizations
    };

    # EFI System Partition (unencrypted, required for Secure Boot)
    "/boot" = {
      device = "/dev/disk/by-partlabel/esp";
      fsType = "vfat";
      options = [ "umask=0077" "defaults" ];
    };
  };

  # Swap file on encrypted root (hibernation support)
  # Size should be >= RAM size for reliable hibernation
  swapDevices = [
    {
      device = "/swapfile";
      size = 16384;  # Size in MB (16GB for ~16GB RAM)
    }
  ];

  # SSD optimizations
  services.fstrim.enable = true;
}
