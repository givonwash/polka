{ config, ... }:
let
  cfg = config._.givon;
  theme = cfg.theme;
in
{
  home-manager.users.givon = {
    gtk = {
      enable = true;
      cursorTheme = {
        name = theme.cursor.name;
        package = theme.cursor.package;
        size = theme.cursor.size;
      };
      font = {
        name = theme.fonts.sans-serif.name;
        package = theme.fonts.sans-serif.package;
        size = theme.fonts.defaultSize;
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
