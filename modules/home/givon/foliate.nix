{ config, pkgs, lib, ... }:

let
  inherit (builtins) elemAt toJSON;
  inherit (config._.givon.userConfig) name;
  inherit (config._.givon.theme) colors;
  cfg = config._.givon.foliate;
in
{
  options._.givon.foliate.enable = lib.mkEnableOption "foliate";
  config.home-manager.users.${name} = lib.mkIf cfg.enable {
    home.packages = [ pkgs.foliate ];
    xdg.configFile."com.github.johnfactotum.Foliate/themes.json".text = toJSON {
      themes = [
        {
          theme-name = "custom-${name}-dark";
          fg-color = colors.white;
          bg-color = elemAt colors.blacks 2;
          link-color = colors.rosewater;
          invert = false;
          dark-mode = true;
        }
        {
          theme-name = "custom-${name}-light";
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
