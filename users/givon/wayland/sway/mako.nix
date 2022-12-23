{ me, ... }: { config, lib, ... }:

let
  cfg = config._.${me};
  theme = cfg.theme;
  inherit (builtins) elemAt;
  inherit (lib) mkIf;
in
{
  home-manager.users.${me} = { config, pkgs, ... }: mkIf cfg.sway.enable {
    programs.mako = {
      enable = true;
      anchor = "top-right";
      backgroundColor = elemAt theme.colors.blacks 0;
      borderColor = theme.colors.peach;
      extraConfig = ''
        [app-name=Spotify]
        default-timeout=3000

        [urgency=high]
        border-color=${theme.colors.red}

        [grouped=true]
        format=<span color='${theme.colors.rosewater}' weight='bold'>(%g) %a: %s</span>\n%b

        [mode=do-not-disturb]
        invisible=1

        [mode=abbreviate]
        format=<span color='${theme.colors.rosewater}' weight='bold'>%a</span>
      '';
      font = "${theme.fonts.sans-serif.name} 12";
      format = "<span color='${theme.colors.rosewater}' weight='bold'>%a: %s</span>\\n%b";
      groupBy = "app-name,summary";
      height = 150;
      iconPath = "${theme.icons.package}/share/icons/${theme.icons.name}";
      layer = "overlay";
      progressColor = "over ${theme.colors.green}";
      textColor = "${theme.colors.white}";
      width = 400;
    };

    services.swayidle.events = [
      { event = "lock"; command = "${pkgs.mako}/bin/makoctl mode -a abbreviate"; }
      { event = "unlock"; command = "${pkgs.mako}/bin/makoctl mode -r abbreviate"; }
    ];

    wayland.windowManager.sway.config.keybindings =
      let
        inherit (cfg.sway.keys) modifier;
      in
      {
        "${modifier}+d" = "exec ${pkgs.mako}/bin/makoctl dismiss";
        "${modifier}+shift+d" = "exec ${pkgs.mako}/bin/makoctl dismiss --all";
        "${modifier}+z" = "exec ${pkgs.mako}/bin/makoctl mode -a do-not-disturb";
        "${modifier}+shift+z" = "exec ${pkgs.mako}/bin/makoctl mode -r do-not-disturb";
      };
  };
}

