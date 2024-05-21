{ pkgs, lib, config, ... }:

let
  cfg = config._.pamplemousse.sway;
in
{
  options._.pamplemousse.sway.enable = lib.mkEnableOption "sway";
  config.programs.sway = lib.mkIf cfg.enable {
    enable = true;
    extraPackages = with pkgs; [ dmenu foot ];
    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND=1
      export MOZ_DBUS_REMOTE=1
      export _JAVA_AWT_NONREPARENTING=1
    '';
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
  };
}
