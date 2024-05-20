{ lib, config, ... }:
let
  cfg = config._.givon.wayland.gnome or {};
in
lib.mkIf (cfg.enable or false) {
  services.gnome.gnome-browser-connector.enable = true;
}
