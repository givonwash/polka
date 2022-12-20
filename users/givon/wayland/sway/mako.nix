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
      defaultTimeout = 5000;
      extraConfig = ''
        [urgency=high]
        border-color=${theme.colors.red}

        [grouped=true]
        format=<span color='${theme.colors.rosewater}' weight='bold'>(%g) %a: %s</span>\n%b
      '';
      font = "${theme.fonts.sans-serif.name} 12";
      format = "<span color='${theme.colors.rosewater}' weight='bold'>%a: %s</span>\\n%b";
      layer = "overlay";
      progressColor = "over ${theme.colors.green}";
      textColor = "${theme.colors.white}";
    };

    wayland.windowManager.sway.config.keybindings =
      let
        inherit (cfg.sway.keys) modifier;
      in
      {
        "${modifier}+d" = "exec ${pkgs.mako}/bin/makoctl dismiss -n";
        "${modifier}+shift+d" = "exec ${pkgs.mako}/bin/makoctl dismiss --all";
      };
  };
}

