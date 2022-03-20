{ me, ... }: { config, ... }:

let
  cfg = config._.${me};
in
{
  home-manager.users.${me} = { pkgs, ... }: {
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
      "wofi/style.css".source = ./style.css;
    };
  };
}
