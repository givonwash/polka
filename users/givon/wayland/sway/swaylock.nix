{ me, ... }: { config, lib, pkgs, ... }:

let
  cfg = config._.${me};
  theme = cfg.theme;

  inherit (builtins) elemAt;
  inherit (lib) mkIf;
in
{
  config = mkIf (cfg.sway.enable && cfg.sway.locker == pkgs.swaylock)
    {
      home-manager.users.${me} = { pkgs, ... }:
        let
          light = "${pkgs.light}/bin/light";
          swaylock = "${pkgs.swaylock}/bin/swaylock";
          swaymsg = "${cfg.sway.package}/bin/swaymsg";
        in
        {
          home.packages = [ pkgs.swaylock ];

          swayidle = {
            enable = true;
            events = [
              { event = "lock"; command = "${swaylock}"; }
              { event = "before-sleep"; command = "${swaylock}"; }
            ];
            timeouts = [
              {
                timeout = 300;
                command = "${light} -O && ${light} -S 1";
                resumeCommand = "${light} -I";
              }
              {
                timeout = 360;
                command = "${swaymsg} \"output * dpms off\"";
                resumeCommand = "${swaymsg} \"output * dpms on\"";
              }
            ];
          };

          xdg.configFile."swaylock/config".text =
            let
              inherit (theme) fonts colors wallpapers;
              inherit (lib.strings) removePrefix;
              blue = removePrefix colors.blue;
              green = removePrefix colors.green;
              red = removePrefix colors.red;
              rosewater = removePrefix colors.rosewater;
              yellow = removePrefix colors.yellow;
              white = removePrefix colors.white;
              black = removePrefix (elemAt colors.blacks 2);
            in
            ''
              bs-hl-color=${yellow}
              caps-lock-bs-hl-color=${yellow}
              caps-lock-key-hl-color=${green}
              color=${black}
              daemonize
              font-size=20
              font="${fonts.sans-serif.name}"
              image=${wallpapers."*".source}
              indicator-caps-lock
              indicator-idle-visible
              indicator-radius=100
              inside-caps-lock-color=${black}
              inside-clear-color=${rosewater}
              inside-color=${black}
              inside-ver-color=${blue}
              inside-wrong-color=${red}
              key-hl-color=${green}
              line-uses-ring
              ring-caps-lock-color=${black}
              ring-clear-color=${rosewater}
              ring-color=${black}
              ring-ver-color=${blue}
              ring-wrong-color=${red}
              scaling=stretch
              separator-color=${black}
              show-failed-attempts
              text-caps-lock-color=${white}
              text-clear-color=${black}
              text-color=${white}
              text-ver-color=${black}
              text-wrong-color=${black}
            '';
        };
      programs.light.enable = true;
      security.pam.services.swaylock = { };
    };
}
