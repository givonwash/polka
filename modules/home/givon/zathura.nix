{ config, lib, ... }:

let
  inherit (config._.givon) theme;
  inherit (theme) colors fonts;
  inherit (builtins) elemAt;
  inherit (config._.givon.userConfig) name;

  cfg = config._.givon.zathura;
in
{
  options._.givon.zathura.enable = lib.mkEnableOption "zathura";
  config.home-manager.users.${name}.programs.zathura = lib.mkIf cfg.enable {
    enable = true;
    options = with colors; {
      abort-clear-search = true;
      adjust-open = "width";
      advance-pages-per-row = false;
      completion-bg = elemAt blacks 3;
      completion-fg = white;
      completion-group-bg = elemAt blacks 3;
      completion-group-fg = blue;
      completion-highlight-bg = elemAt blacks 4;
      completion-highlight-fg = white;
      default-bg = elemAt blacks 2;
      default-fg = white;
      font = "${fonts.monospace.name} 12";
      highlight-active-color = pink;
      highlight-color = elemAt blacks 4;
      highlight-fg = pink;
      incremental-search = true;
      index-active-bg = elemAt blacks 3;
      index-active-fg = white;
      index-bg = elemAt blacks 2;
      index-fg = white;
      inputbar-bg = elemAt blacks 3;
      inputbar-fg = white;
      notification-bg = elemAt blacks 3;
      notification-error-bg = elemAt blacks 3;
      notification-error-fg = red;
      notification-fg = white;
      notification-warning-bg = elemAt blacks 3;
      notification-warning-fg = yellow;
      recolor = true;
      recolor-darkcolor = white;
      recolor-lightcolor = elemAt blacks 2;
      render-loading-bg = elemAt blacks 2;
      render-loading-fg = white;
      scroll-page-aware = false;
      window-title-home-tilde = true;
    };
  };
}
