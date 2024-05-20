{ config, pkgs, lib, ... }:

let
  inherit (config._.givon) theme;
  inherit (config._.givon.userConfig) name;
  inherit (config._.wayland) sway;
  inherit (builtins) readFile;
  cfg = config._.givon.wayland.sway.wofi;
in
{
  options._.givon.wayland.sway.wofi.enable = lib.mkEnableOption "wofi";
  config.home-manager.users.${name} = lib.mkIf cfg.enable {
    home.packages = [ pkgs.wofi ];

    xdg.configFile = {
      "wofi/config".text = ''
        allow_images=true
        allow_markup=true
        columns=1
        drun-display_generic=true
        drun-separator="\\n"
        dynamic_lines=true
        hide_scroll=false
        insensitive=true
        key_exit=Escape
        key_expand=Alt_L
        key_submit=Return
        layer=overlay
        mode=drun
        parse_search=true
        prompt=:: 🍉 ::
        term=${sway.terminal.executable}
      '';
      "wofi/style.css".text = ''
        ${lib.polka.css.mkGtkColors theme.colors}

        ${readFile ./style.css}
      '';
    };
  };
}
