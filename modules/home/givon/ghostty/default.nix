{ config, pkgs, lib, ... }:

let
  inherit (builtins) elemAt toString;
  inherit (config._.givon) theme;
  inherit (theme) colors fonts;
  inherit (config._.givon.userConfig) name;
  cfg = config._.givon.ghostty;
  package = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;

  ansi = [
    (elemAt colors.grays 0)
    colors.red
    colors.green
    colors.yellow
    colors.blue
    colors.pink
    colors.sky
    (elemAt colors.grays 2)
  ];
  brights = [
    (elemAt colors.grays 1)
    colors.red
    colors.green
    colors.yellow
    colors.blue
    colors.pink
    colors.sky
    colors.white
  ];
  renderPalette = offset: palette:
    lib.concatStringsSep "\n" (
      lib.imap0 (index: color: "palette = ${toString (offset + index)}=${color}") palette
    );
in
{
  options._.givon.ghostty = {
    enable = lib.mkEnableOption "Ghostty";
    enableInstallation = lib.mkOption {
      description = "Enable installation of the `ghostty` package";
      default = true;
      type = lib.types.bool;
    };
    appearance.fontSize = lib.mkOption {
      description = "Font size";
      default = fonts.defaultSize * fonts.defaultScalingFactor;
      type = with lib.types; addCheck (oneOf [ int float ]) (n: n > 0);
    };
  };

  config.home-manager.users.${name} = lib.mkIf cfg.enable {
    home.packages = lib.optional cfg.enableInstallation package;
    xdg.configFile."ghostty/config".text = ''
      background = ${elemAt colors.blacks 2}
      foreground = ${colors.white}
      selection-background = ${elemAt colors.blacks 4}
      selection-foreground = ${colors.white}
      cursor-color = ${colors.rosewater}
      cursor-text = ${elemAt colors.blacks 2}
      cursor-style = bar
      cursor-style-blink = false
      split-divider-color = ${elemAt colors.blacks 0}
      mouse-hide-while-typing = false

      ${renderPalette 0 ansi}
      ${renderPalette 8 brights}
      palette = 16=${colors.peach}
      palette = 17=${colors.rosewater}

      font-family = ${fonts.monospace.name}
      font-size = ${toString cfg.appearance.fontSize}
      font-feature = -calt,-clig,-liga

      ${lib.optionalString pkgs.stdenv.hostPlatform.isDarwin "macos-titlebar-style = tabs"}
      confirm-close-surface = true

      keybind = ctrl+shift+c=copy_to_clipboard
      keybind = ctrl+shift+v=paste_from_clipboard
      keybind = ctrl+minus=decrease_font_size:1
      keybind = ctrl+equal=increase_font_size:1
      keybind = ctrl+0=reset_font_size

      keybind = ctrl+space>n=new_tab
      keybind = ctrl+space>shift+c=close_tab
      keybind = ctrl+space>ctrl+j=move_tab:-1
      keybind = ctrl+space>ctrl+k=move_tab:1
      keybind = ctrl+space>1=goto_tab:1
      keybind = ctrl+space>2=goto_tab:2
      keybind = ctrl+space>3=goto_tab:3
      keybind = ctrl+space>4=goto_tab:4
      keybind = ctrl+space>5=goto_tab:5
      keybind = ctrl+space>6=goto_tab:6
      keybind = ctrl+space>7=goto_tab:7
      keybind = ctrl+space>8=goto_tab:8
      keybind = ctrl+space>9=goto_tab:9
      keybind = ctrl+space>0=goto_tab:10
      keybind = ctrl+space>shift+j=previous_tab
      keybind = ctrl+space>shift+k=next_tab

      keybind = ctrl+space>apostrophe=new_split:right
      keybind = ctrl+space>semicolon=new_split:down
      keybind = ctrl+space>c=close_surface
      keybind = ctrl+space>h=goto_split:left
      keybind = ctrl+space>j=goto_split:down
      keybind = ctrl+space>k=goto_split:up
      keybind = ctrl+space>l=goto_split:right

      keybind = ctrl+space>f=scroll_page_up
      keybind = ctrl+space>b=scroll_page_down
      keybind = ctrl+space>shift+l=clear_screen
      keybind = ctrl+space>ctrl+space=text:\x00
    '';
  };
}
