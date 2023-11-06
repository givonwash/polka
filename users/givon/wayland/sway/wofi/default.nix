{ config, lib, me, pkgs, polkaUtils, ... }:

let
  cfg = config._.${me};
  theme = cfg.theme;
  inherit (builtins) concatStringsSep isList readFile toString;
  inherit (lib) attrsets lists;
in
{
  home-manager.users.${me} = { ... }: {
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
        term=${cfg.sway.terminal.executable}
      '';
      "wofi/style.css".text = ''
        ${polkaUtils.css.mkGtkColors theme.colors}

        ${readFile ./style.css}
      '';
    };
  };
}
