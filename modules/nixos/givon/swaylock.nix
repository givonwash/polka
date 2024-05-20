{ lib, config, ... }:

let
  cfg = config._.givon.wayland.sway.swaylock;
in
lib.mkIf cfg.enable {
  security.pam.services.swaylock = { };
}
