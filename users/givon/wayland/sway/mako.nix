{ me, ... }: { config, lib, pkgs, ... }:

let
  cfg = config._.${me};
  theme = cfg.theme;
  inherit (builtins) elemAt;
  inherit (lib) mkIf;
in
{
  home-manager.users.${me} = mkIf cfg.sway.enable {
    programs.mako =
      let
        createFormat = { font-color, withGroup ? false, withSummary ? true, withBody ? true }:
          let
            group = if withGroup then "(%g) " else "";
            summary = if withSummary then ": %s" else "";
            heading = "${group}%a${summary}";
            body = if withBody then "\\n%b" else "";
          in
          "<span color='${font-color}' weight='bold'>${heading}</span>${body}";
      in
      {
        enable = true;
        anchor = "top-right";
        backgroundColor = elemAt theme.colors.blacks 0;
        borderColor = theme.colors.peach;
        defaultTimeout = 10000;
        extraConfig = ''
          [app-name=Spotify]
          default-timeout=3000

          [app-name=Slack]
          default-timeout=0

          [actionable]
          format=${createFormat { font-color = theme.colors.lavender; }}

          [urgency=high]
          border-color=${theme.colors.red}

          [grouped]
          format=${createFormat { font-color = theme.colors.rosewater; withGroup = true; }}

          [actionable grouped]
          format=${createFormat { font-color = theme.colors.lavender; withGroup = true; }}

          [mode=do-not-disturb]
          invisible=1

          [mode=abbreviate]
          format=${createFormat { font-color = theme.colors.rosewater; withSummary = false; withBody = false; }}
        '';
        font = "${theme.fonts.sans-serif.name} 12";
        format = createFormat { font-color = theme.colors.rosewater; };
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

