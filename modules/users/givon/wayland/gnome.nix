{ config, lib, ... }:

let
  cfg = config._.givon;
  inherit (lib) mkEnableOption mkIf;
in
{
  options. _.givon. gnome = {
    enable = mkEnableOption "gnome";
  };

  config = mkIf cfg.gnome.enable {
    home-manager.users.givon = { lib, ... }:
      let
        inherit (cfg.theme) colors cursor fonts;
        inherit (lib) mkForce;
        inherit (lib.hm) gvariant;
        inherit (lib.strings) removePrefix;
        inherit (lib.polka.colors) fromHexIntoRGBA;
      in
      {
        dconf.settings = {
          "org/gnome/desktop/interface" = {
            clock-format = "12h";
            color-scheme = "prefer-dark";
            cursor-theme = cursor.name;
            document-font-name = "${fonts.serif.name} 11";
            enable-animations = true;
            enable-hot-corners = false;
            font-name = mkForce "${fonts.sans-serif.name} 11";
            monospace-font-name = "${fonts.monospace.name} 11";
          };
          "org/gnome/desktop/peripherals/keyboard" = {
            delay = gvariant.mkUint32 250;
            repeat-interval = gvariant.mkUint32 30;
          };
          "org/gnome/desktop/peripherals/mouse" = {
            natural-scroll = true;
          };
          "org/gnome/desktop/peripherals/touchpad" = {
            tap-and-drag = false;
            tap-to-click = true;
          };
          "org/gnome/desktop/wm/keybindings" = {
            close = [ "<Super>x" ];
            maximize = [ ];
            minimize = [ ];
            move-to-monitor-down = [ ];
            move-to-monitor-left = [ ];
            move-to-monitor-right = [ ];
            move-to-monitor-up = [ ];
            move-to-workspace-1 = [ "<Super><Shift>1" ];
            move-to-workspace-2 = [ "<Super><Shift>2" ];
            move-to-workspace-3 = [ "<Super><Shift>3" ];
            move-to-workspace-4 = [ "<Super><Shift>4" ];
            move-to-workspace-5 = [ "<Super><Shift>5" ];
            move-to-workspace-6 = [ "<Super><Shift>6" ];
            move-to-workspace-7 = [ "<Super><Shift>7" ];
            move-to-workspace-8 = [ "<Super><Shift>8" ];
            move-to-workspace-9 = [ "<Super><Shift>9" ];
            move-to-workspace-down = [ ];
            move-to-workspace-last = [ ];
            move-to-workspace-left = [ ];
            move-to-workspace-right = [ ];
            move-to-workspace-up = [ ];
            switch-group = [ ];
            switch-group-backward = [ ];
            switch-input-source = [ ];
            switch-input-source-backward = [ ];
            switch-to-workspace-1 = [ "<Super>1" ];
            switch-to-workspace-2 = [ "<Super>2" ];
            switch-to-workspace-3 = [ "<Super>3" ];
            switch-to-workspace-4 = [ "<Super>4" ];
            switch-to-workspace-5 = [ "<Super>5" ];
            switch-to-workspace-6 = [ "<Super>6" ];
            switch-to-workspace-7 = [ "<Super>7" ];
            switch-to-workspace-8 = [ "<Super>8" ];
            switch-to-workspace-9 = [ "<Super>9" ];
            switch-to-workspace-down = [ ];
            switch-to-workspace-last = [ "<Super>0" ];
            switch-to-workspace-left = [ ];
            switch-to-workspace-right = [ ];
            switch-to-workspace-up = [ ];
            toggle-fullscreen = [ "<Super>f" ];
            toggle-maximized = [ "<Super>m" ];
            unmaximize = [ ];
          };
          "org/gnome/desktop/wm/preferences" = {
            focus-mode = "sloppy";
            titlebar-font = "${fonts.sans-serif.name} 11";
          };
          "org/gnome/mutter" = {
            overlay-key = "";
          };
          "org/gnome/mutter/wayland/keybindings" = {
            restore-shortcuts = [ ];
          };
          "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions = [
              "native-window-placement@gnome-shell-extensions.gcampax.github.com"
              "pop-shell@system76.com"
              "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
            ];
          };
          "org/gnome/shell/extensions/pop-shell" = {
            active-hint = true;
            active-hint-border-radius = 1;
            hint-color-rgba = fromHexIntoRGBA (removePrefix "#" colors.lavender) 1;
            show-title = false;
            snap-to-grid = true;
            tile-by-default = true;
          };
          "org/gnome/shell/keybindings" = {
            open-application-menu = [ "<Super>u" ];
            toggle-message-tray = [ "<Super>v" ];
            toggle-overview = [ "<Super>space" ];
            switch-to-application-1 = [ ];
            switch-to-application-2 = [ ];
            switch-to-application-3 = [ ];
            switch-to-application-4 = [ ];
            switch-to-application-5 = [ ];
            switch-to-application-6 = [ ];
            switch-to-application-7 = [ ];
            switch-to-application-8 = [ ];
            switch-to-application-9 = [ ];
          };
          "org/gnome/settings-daemon/plugins/color" = {
            night-light-enabled = true;
          };
          "org/gnome/settings-daemon/plugins/media-keys" = {
            rotate-video-lock-static = [ ];
          };
          "org/gnome/system/location" = {
            enabled = true;
          };
        };
      };

    services.gnome.gnome-browser-connector.enable = true;
  };
}
