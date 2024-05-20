{ pkgs, lib, config, ... }:

let
  cfg = config._.givon.wayland.sway or { };
in
lib.mkIf (cfg.enable or false) {
  environment.systemPackages = [ pkgs.pulseaudio ];
  programs = {
    dconf.enable = true;
    light.enable = true;
  };
  xdg.portal.wlr.enable = true;
}
