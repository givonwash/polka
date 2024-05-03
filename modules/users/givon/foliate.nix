{ config, pkgs, ... }:

let
  inherit (builtins) elemAt toJSON;
  colors = config._.givon.theme.colors;
in
{
  home-manager.users.givon = {
    home.packages = [ pkgs.foliate ];
    xdg.configFile."com.github.johnfactotum.Foliate/themes.json".text = toJSON {
      themes = [
        {
          theme-name = "custom-givon-dark";
          fg-color = colors.white;
          bg-color = elemAt colors.blacks 2;
          link-color = colors.rosewater;
          invert = false;
          dark-mode = true;
        }
        {
          theme-name = "custom-givon-light";
          fg-color = elemAt colors.blacks 2;
          bg-color = colors.white;
          link-color = colors.rosewater;
          invert = false;
          dark-mode = true;
        }
      ];
    };
  };
}
