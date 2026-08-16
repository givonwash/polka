{ pkgs, lib, config, ... }:

let
  cfg = config._.frambuesa.gnome;
in
{
  options._.frambuesa.gnome.enable = lib.mkEnableOption "gnome";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      dconf-editor
      gnomeExtensions.pop-shell
      pop-launcher
    ];
    services = {
      gnome = {
        core-os-services.enable = true;
        core-shell.enable = true;
        core-apps.enable = true;
      };
      desktopManager.gnome.enable = true;
      xserver.enable = true;
    };
  };
}
