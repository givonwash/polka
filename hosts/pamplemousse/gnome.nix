{ pkgs, ... }:

{
  services = {
    gnome = {
      core-os-services.enable = true;
      core-shell.enable = true;
      core-utilities.enable = true;
    };
    xserver = {
      enable = true;
      desktopManager.gnome = {
        enable = true;
      };
    };
  };
}
