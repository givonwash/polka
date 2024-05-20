{ ... }:

{
  boot = {
    initrd = {
      availableKernelModules = [
        "ahci"
        "ehci_pci"
        "mptspi"
        "sd_mod"
        "sr_mod"
        "uhci_hcd"
        "ata_piix"
      ];
      kernelModules = [ ];
    };
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
    kernelModules = [ ];
    extraModulePackages = [ ];
  };
}
