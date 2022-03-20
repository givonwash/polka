{ me, ... }: { config, lib, ... }:

let
  cfg = config._.${me};
  theme = cfg.theme;
  inherit (builtins) listToAttrs;
  inherit (lib) mkIf;
in
{
  home-manager.users.${me} = { pkgs, ... }: mkIf cfg.sway.enable {
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
              default = "";
            } // (listToAttrs (map
              (workspace: { name = workspace.name; value = workspace.icon; })
              cfg.sway.workspaces
            ));
          };
          "sway/window" = {
            format = "<span weight='bold'>{}</span>";
            max-length = 50;
            rewrite = {
              "(.*)\\s*—\\s*(Mozilla )?Firefox?$" = "<span color='${theme.colors.red}'></span> $1";
            };
          };
          clock = {
            format = "<span color='${theme.colors.yellow}'> </span>{:%a %b %d %I:%M %p}";
            interval = 60;
            tooltip-format = "<span face='${theme.fonts.monospace.name}'>{calendar}</span>";
          };
          battery = {
            states = {
              okay = 40;
              poor = 20;
              critical = 5;
            };
            format = "{icon}";
            format-icons = [ "" "" "" "" "" ];
            tooltip-format = "{capacity}%";
          };
          network = {
            format-ethernet = "";
            format-wifi = "";
            format-disconnected = "";
            format-disabled = "";
            max-length = 30;
            tooltip-format = "Network: {essid}\nStrength: {signalStrength}\nFrequency: {frequency}";
          };
          pulseaudio = {
            format = "{icon}";
            format-bluetooth = "{icon} ";
            format-muted = "";
            format-icons =
              {
                headphone = "";
                hands-free = "";
                headset = "";
                phone = "";
                car = "";
                default = [ "" "" "" ];
              };
            on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
            scroll-step = 0;
            tooltip-format = "{volume}%";
          };
        };
      };
      style = ./style.css;
      systemd = {
        enable = true;
        target = "sway-session.target";
      };
    };
  };
}
