{ config, me, pkgs, ... }:
let
  cfg = config._.${me};
  theme = cfg.theme;
in
{
  home-manager.users.${me} = {
    gtk = with pkgs; {
      enable = true;
      cursorTheme = {
        name = theme.cursor.name;
        package = theme.cursor.package;
        size = 24;
      };
      font = {
        name = theme.fonts.sans-serif.name;
        package = theme.fonts.sans-serif.package;
        size = 13;
      };
      iconTheme = {
        name = theme.icons.name;
        package = theme.icons.package;
      };
      theme = {
        name = theme.gtkTheme.name;
        package = theme.gtkTheme.package;
      };
    };
  };
}
