{ me, ... }: { config, lib, pkgs, ... }:

let
  cfg = config._.${me};
  theme = cfg.theme;

  inherit (builtins) elemAt;
  inherit (lib) mkIf;
in
{
  config = mkIf (cfg.sway.enable && cfg.sway.locker.package == pkgs.swaylock)
    {
      home-manager.users.${me} = { pkgs, ... }: {
        xdg.configFile."swaylock/config".text =
          let
            inherit (theme) fonts colors wallpaper;
            inherit (lib.strings) removePrefix;
            removeHashtag = hex: removePrefix "#" hex;
            blue = removeHashtag colors.blue;
            green = removeHashtag colors.green;
            red = removeHashtag colors.red;
            rosewater = removeHashtag colors.rosewater;
            yellow = removeHashtag colors.yellow;
            white = removeHashtag colors.white;
            black = removeHashtag (elemAt colors.blacks 2);
          in
          ''
            bs-hl-color=${yellow}
            caps-lock-bs-hl-color=${yellow}
            caps-lock-key-hl-color=${green}
            color=${black}
            daemonize
            font-size=20
            font="${fonts.sans-serif.name}"
            image=${wallpaper}
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
      security.pam.services.swaylock = { };
    };
}
