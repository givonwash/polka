{ config, pkgs, ... }:

let
  inherit (builtins) elemAt readFile;
  cfg = config._.givon;
  theme = cfg.theme;
  colors = theme.colors;
  fonts = theme.fonts;
in
{
  home-manager.users.givon = {
    home.packages = [ pkgs.wezterm ];
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
              monospace = "${fonts.monospace.name}",
              ["sans-serif"] = "${fonts.sans-serif.name}",
          }
      }

      local enable_wayland = ${if cfg.sway.enable or cfg.gnome.enable then "true" else "false"}

      ${readFile ./wezterm.lua}
    '';
  };
}
