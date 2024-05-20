{ lib, config, ... }:
let
  inherit (config._.givon) theme;
  inherit (config._.givon.userConfig) name;
  cfg = config._.givon.gtk;
in
{
  options._.givon.gtk.enable = lib.mkEnableOption "gtk";
  config.home-manager.users.${name} = lib.mkIf cfg.enable {
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
