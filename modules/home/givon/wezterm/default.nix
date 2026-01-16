{ config, pkgs, lib, ... }:

let
  inherit (builtins) elemAt readFile toString;
  inherit (config._.givon) theme;
  inherit (theme) colors fonts;
  inherit (config._.givon.userConfig) name;
  cfg = config._.givon.wezterm;
in
{
  options._.givon.wezterm = {
    enable = lib.mkEnableOption "wezterm";
    enableInstallation = lib.mkOption rec {
      description = "Enable installation of `wezterm` package";
      example = default;
      default = true;
      type = lib.types.bool;
    };
    enableWayland = lib.mkOption rec {
      description = "Lua expression to pass to wezterm's `enable_wayland` option";
      example = default;
      default = "true";
      type = lib.types.str;
    };
    appearance = {
      fontSize = lib.mkOption rec {
        description = "Font size";
        default = fonts.defaultSize * fonts.defaultScalingFactor;
        example = default;
        type = with lib.types; addCheck (oneOf [ int float ]) (n: n > 0);
      };
      windowDecorations = lib.mkOption rec {
        description = "Decorations for Wezterm windows";
        example = default;
        default = "TITLE | RESIZE";
        type = lib.types.str;
      };
    };
  };
  config.home-manager.users.${name} = lib.mkIf cfg.enable {
    home.packages = lib.optional (cfg.enableInstallation) pkgs.wezterm;
    xdg.configFile."wezterm/wezterm.lua".text = ''
      local theme =  {
          colors = {
              ansi = {
                  "${elemAt colors.grays 0}",
                  "${colors.red}",
                  "${colors.green}",
                  "${colors.yellow}",
                  "${colors.blue}",
                  "${colors.pink}",
                  "${colors.sky}",
                  "${elemAt colors.grays 2}"
              },
              brights = {
                  "${elemAt colors.grays 1}",
                  "${colors.red}",
                  "${colors.green}",
                  "${colors.yellow}",
                  "${colors.blue}",
                  "${colors.pink}",
                  "${colors.sky}",
                  "${colors.white}"
              },
              background = "${elemAt colors.blacks 2}",
              compose_cursor = "${colors.peach}",
              cursor_bg = "${colors.rosewater}",
              cursor_border = "${colors.rosewater}",
              cursor_fg = "${elemAt colors.blacks 2}",
              foreground = "${colors.white}",
              indexed = {
                  [16] = "${colors.peach}",
                  [17] = "${colors.rosewater}"
              },
              scrollbar_thumb = "${elemAt colors.blacks 4}",
              selection_bg = "${elemAt colors.blacks 4}",
              selection_fg = "${colors.white}",
              split = "${elemAt colors.blacks 0}",
              tab_bar = {
                  active_tab = {
                      bg_color = "${elemAt colors.blacks 1}",
                      fg_color = "${colors.blue}",
                      intensity = 'Bold'
                  },
                  background = "${elemAt colors.blacks 2}",
                  inactive_tab = {
                      bg_color = "${elemAt colors.blacks 1}",
                      fg_color = "${colors.white}",
                      intensity = 'Bold'
                  },
                  inactive_tab_hover = {
                      bg_color = "${elemAt colors.blacks 3}",
                      fg_color = "${colors.white}"
                  },
                  new_tab = {
                      bg_color = "${elemAt colors.blacks 3}",
                      fg_color = "${elemAt colors.grays 0}"
                  },
                  new_tab_hover = {
                      bg_color = "${elemAt colors.blacks 3}",
                      fg_color = "${colors.white}"
                  },
              },
              visual_bell = "${elemAt colors.blacks 3}",
          },
          fonts = {
              default_size = ${toString cfg.appearance.fontSize},
              monospace = { name = "${fonts.monospace.name}" },
              ["sans-serif"] = { name = "${fonts.sans-serif.name}" }
          },
          window_decorations = "${cfg.appearance.windowDecorations}"
      }

      local enable_wayland = ${cfg.enableWayland}

      ${readFile ./wezterm.lua}
    '';
  };
}
