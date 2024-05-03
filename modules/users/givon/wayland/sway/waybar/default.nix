{ config, pkgs, lib, ... }:

let
  cfg = config._.givon;
  theme = cfg.theme;
  inherit (builtins) listToAttrs readFile;
  inherit (lib) mkIf;
in
{
  home-manager.users.givon = mkIf cfg.sway.enable {
    home.packages = with pkgs; [
      pavucontrol
    ];
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          name = "main";
          layer = "top";
          output = [ "eDP-1" "DP-1" ];
          position = "bottom";
          modules-left = [ "sway/workspaces" ];
          modules-center = [ "sway/window" ];
          modules-right = [ "pulseaudio" "battery" "network" "clock" ];
          "sway/workspaces" = {
            disable-scroll = true;
            numeric-first = false;
            format = "{icon}";
            format-icons = {
              default = "[?]";
            } // (listToAttrs (map
              (workspace: { name = workspace.name; value = workspace.icon; })
              cfg.sway.workspaces
            ));
          };
          "sway/window" = {
            format = ":: <span weight='bold'>{}</span> ::";
            max-length = 50;
            rewrite = {
              "(.*)\\s*—\\s*(Mozilla )?Firefox?$" = "$1";
            };
          };
          clock = {
            format = "[{:%a %b %d %I:%M %p}]";
            interval = 60;
            tooltip-format = "<span face='${theme.fonts.monospace.name}'>{calendar}</span>";
          };
          battery = {
            format = "[{capacity}%]";
            format-charging = "[~~]";
            format-full = "[!!]";
            states = {
              okay = 40;
              poor = 20;
              critical = 5;
            };
          };
          network = {
            format-ethernet = "[{ifname}]";
            format-wifi = "[{essid}: {signalStrength}%]";
            format-disconnected = "[<span color='${theme.colors.red}'>X</span>]";
            format-disabled = "[#]";
            max-length = 30;
            tooltip-format = "Interface: {ifname}\nIP: {ipaddr}\nGateway: {gwaddr}";
          };
          pulseaudio = {
            format = "{format_source}::[{volume}%]";
            format-source = "[{volume}%]";
            format-source-muted = "[<span color='${theme.colors.red}'>X</span>]";
            format-muted = "{format_source}::[<span color='${theme.colors.red}'>X</span>]";
            on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
            scroll-step = 0;
            tooltip-format = "{desc}: {volume}%";
          };
        };
      };
      style = ''
        ${lib.polka.css.mkGtkColors theme.colors}

        ${readFile ./style.css}
      '';
      systemd = {
        enable = true;
        target = "sway-session.target";
      };
    };
  };
}
