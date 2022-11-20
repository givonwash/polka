{ me, utils, ... }: { config, lib, pkgs, ... }:

let
  cfg = config._.${me}.sway;
  theme = config._.${me}.theme;
  inherit (builtins) elemAt length listToAttrs sort stringLength toString;
  inherit (lib) lists literalExpression mkIf mkEnableOption mkPackageOption mkOption types;
in
{
  imports = [
    (import ./swaylock.nix { inherit me; })
    (import ./waybar { inherit me utils; })
    (import ./wofi { inherit me utils; })
  ];

  options._.${me}.sway = {
    enable = mkEnableOption "sway";
    keys =
      let
        mkKeyOption = key: default: mkOption {
          inherit default;
          type = types.str;
          example = default;
          description = ''
            Value to use for ${key}
          '';
        };
      in
      listToAttrs (
        lists.zipListsWith (key: example: { name = key; value = mkKeyOption key example; })
          [ "modifier" "left" "down" "up" "right" ]
          [ "Mod4" "h" "j" "k" "l" ]
      );
    launcher = mkOption {
      apply = (pkg:
        if pkg == pkgs.wofi then
          rec {
            package = pkgs.wofi;
            executable = "${package}/bin/wofi";
          }
        else
          throw "Unexpected launcher received: ${pkg}"
      );
      type = types.enum [ pkgs.wofi ];
      example = literalExpression "pkgs.wofi";
      default = pkgs.wofi;
      description = ''
        Launcher to use
      '';
    };
    locker = mkOption {
      apply = (pkg:
        if pkg == pkgs.swaylock then
          rec {
            package = pkgs.swaylock;
            executable = "${package}/bin/swaylock";
          }
        else
          throw "Unexpected locker received: ${pkg}"
      );
      type = types.enum [ pkgs.swaylock ];
      example = literalExpression "pkgs.swaylock";
      default = pkgs.swaylock;
      description = ''
        Package containing supported locker to use
      '';
    };
    terminal = mkOption {
      apply = (pkg:
        if pkg == pkgs.wezterm then
          rec {
            package = pkgs.wezterm;
            executable = "${package}/bin/wezterm";
          }
        else
          throw "Unexpected terminal received: ${pkg}"
      );
      type = types.enum [ pkgs.wezterm ];
      example = literalExpression "pkgs.wezterm";
      default = pkgs.wezterm;
      description = ''
        Package containing supported terminal to use
      '';
    };
    package = mkPackageOption pkgs "sway" { };
    workspaces =
      let
        workspaceOptions = {
          options = {
            key = mkOption {
              type = types.strMatching ".";
              example = "1";
              description = ''
                Key that should be used to navigate/move to workspace.
              '';
            };
            name = mkOption {
              type = types.strMatching "[a-zA-Z0-9_-]+";
              example = "1-web";
              description = ''
                Name that should be associated with workspace where relevant
              '';
            };
            icon = mkOption {
              type = types.str;
              example = "#";
              description = ''
                Icon that should be associated with workspace where relevant
              '';
            };
          };
        };
      in
      mkOption {
        apply = (workspaces: sort (l: r: l.name < r.name) workspaces);
        type = with types;
          addCheck (listOf (submodule workspaceOptions)) (workspaces: length workspaces >= 1);
        default = (
          map
            (n: { key = n; name = "0${n}"; icon = "[${n}]"; })
            (map toString (lists.range 1 9))
        ) ++ [{ key = "0"; name = "10"; icon = "[!]"; }];
        description = ''
          Sway workspaces to create
        '';
      };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.pulseaudio ];

    home-manager.users.${me} = { config, pkgs, ... }: {
      home.packages = with pkgs; [
        cfg.launcher.package
        cfg.locker.package
        cfg.terminal.package
        grim
        jq
        playerctl
        slurp
      ];

      services = {
        kanshi =
          let
            firstWorkspace = elemAt cfg.workspaces 0;
          in
          {
            enable = true;
            profiles = {
              docked = {
                exec = [ "${cfg.package}/bin/swaymsg 'workspace ${firstWorkspace.name}; move workspace to output DP-1'" ];
                outputs = [
                  { criteria = "DP-1"; position = "0,0"; }
                  { criteria = "eDP-1"; position = "3840,0"; }
                ];
              };
            };
          };
        swayidle = {
          enable = true;
          events = [
            { event = "lock"; command = "${cfg.locker.executable}"; }
            { event = "before-sleep"; command = "${cfg.locker.executable}"; }
          ];
          timeouts = [
            {
              timeout = 300;
              command = "${pkgs.light}/bin/light -O && ${pkgs.light}/bin/light -S 1";
              resumeCommand = "${pkgs.light}/bin/light -I";
            }
            {
              timeout = 330;
              command = cfg.locker.executable;
            }
            {
              timeout = 360;
              command = "${cfg.package}/bin/swaymsg \"output * dpms off\"";
              resumeCommand = "${cfg.package}/bin/swaymsg \"output * dpms on\"";
            }
          ];
        };
      };

      wayland.windowManager.sway = {
        enable = true;
        config = {
          inherit (cfg.keys) modifier left down up right;
          bars = [ ];
          colors =
            let
              inherit (theme.colors) blue red white;
              black = elemAt theme.colors.blacks 0;
              gray = elemAt theme.colors.grays 0;
            in
            rec {
              background = black;
              focused = {
                background = black;
                border = blue;
                childBorder = blue;
                indicator = gray;
                text = white;
              };
              focusedInactive = {
                background = black;
                border = blue;
                childBorder = background;
                indicator = gray;
                text = white;
              };
              placeholder = unfocused;
              unfocused = {
                background = black;
                border = black;
                childBorder = black;
                indicator = gray;
                text = white;
              };
              urgent = {
                background = black;
                border = red;
                childBorder = red;
                indicator = gray;
                text = white;
              };
            };
          floating = {
            criteria = [
              { app_id = "^pavucontrol$"; }
              { window_role = "pop-up"; }
              { window_role = "bubble"; }
              { window_role = "dialog"; }
              { window_type = "dialog"; }
            ];
            titlebar = true;
          };
          focus.mouseWarping = false;
          fonts = {
            names = with theme.fonts; [
              "pango:${sans-serif.name}"
              "pango:${icons.name}"
            ];
            style = "reguluar";
            size = 13.0;
          };
          gaps = {
            inner = 20;
            smartBorders = "on";
          };
          input = {
            "type:keyboard" = {
              repeat_delay = "250";
              repeat_rate = "30";
            };
            "type:pointer" = {
              dwt = "enabled";
              natural_scroll = "enabled";
            };
            "type:touchpad" = {
              drag = "disabled";
              dwt = "enabled";
              natural_scroll = "enabled";
              scroll_method = "two_finger";
              tap = "enabled";
              tap_button_map = "lrm";
            };
          };
          keybindings = with cfg.keys; {
            "${modifier}+return" = "exec ${cfg.terminal.executable}";
            "${modifier}+space" = "exec ${cfg.launcher.executable}";
            "${modifier}+period" = "exec ${cfg.locker.executable}";
            "${modifier}+x" = "kill";
            "${modifier}+shift+r" = "reload";
            "${modifier}+shift+e" = "exit";
            "${modifier}+${left}" = "focus left";
            "${modifier}+${down}" = "focus down";
            "${modifier}+${up}" = "focus up";
            "${modifier}+${right}" = "focus right";
            "${modifier}+shift+${left}" = "move left";
            "${modifier}+shift+${down}" = "move down";
            "${modifier}+shift+${up}" = "move up";
            "${modifier}+shift+${right}" = "move right";
            "${modifier}+semicolon" = "splith";
            "${modifier}+v" = "splitv";
            "${modifier}+comma" = "focus mode_toggle";
            "${modifier}+apostrophe" = "sticky toggle";
            "${modifier}+s" = "layout stacking";
            "${modifier}+t" = "layout tabbed";
            "${modifier}+e" = "layout default";
            "${modifier}+f" = "fullscreen toggle";
            "${modifier}+a" = "focus parent";
            "${modifier}+r" = "mode resize";
            "${modifier}+b" = "exec ${pkgs.light}/bin/light -U 5";
            "${modifier}+shift+b" = "exec ${pkgs.light}/bin/light -A 5";
            "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 5";
            "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 5";
            "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
            "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
            "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
            "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
            "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
            "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
            "${modifier}+n" = "exec ${pkgs.playerctl}/bin/playerctl next";
            "${modifier}+p" = "exec ${pkgs.playerctl}/bin/playerctl previous";
            "${modifier}+i" = "inhibit_idle visible";
            "${modifier}+shift+i" = "inhibit_idle none";
            "${modifier}+c" = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\"";
            "${modifier}+shift+c" = "exec ${pkgs.grim}/bin/grim -o \"$(${cfg.package}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name')\"";
          } // (listToAttrs (lists.flatten (map
            (workspace: [
              {
                name = "${modifier}+${workspace.key}";
                value = "workspace \"${workspace.name}\"";
              }
              {
                name = "${modifier}+shift+${workspace.key}";
                value = "move container to workspace \"${workspace.name}\"";
              }
            ])
            cfg.workspaces
          )));
          menu = cfg.launcher.executable;
          modes = {
            resize = {
              w = "resize grow width 10px";
              "shift+w" = "resize shrink width 10px";
              h = "resize grow height 10px";
              "shift+h" = "resize shrink height 10px";
              return = "mode default";
              escape = "mode default";
            };
          };
          output."*".bg = with theme; "${wallpaper} stretch";
          seat."*".xcursor_theme = "${theme.cursor.name} 24";
          terminal = cfg.terminal.executable;
        };
        package = null;
      };
    };
    programs = {
      dconf.enable = true;
      light.enable = true;
    };
    xdg.portal.wlr.enable = true;
  };
}
