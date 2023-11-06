{ config, me, pkgs, ... }:

let
  inherit (builtins) elemAt toJSON;
  colors = config._.${me}.theme.colors;
in
{
  home-manager.users.${me} = {
    home.packages = [ pkgs.foliate ];
    xdg.configFile."com.github.johnfactotum.Foliate/themes.json".text = toJSON {
      themes = [
        {
          theme-name = "custom-${me}-dark";
          fg-color = colors.white;
          bg-color = elemAt colors.blacks 2;
          link-color = colors.rosewater;
          invert = false;
          dark-mode = true;
        }
        {
          theme-name = "custom-${me}-light";
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
