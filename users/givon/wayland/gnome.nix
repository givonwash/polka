{ me, ... }: { config, lib, ... }:

let
  cfg = config._.${me}.gnome;
  inherit (lib) mkEnableOption mkIf types;
in
{
  options._.${me}.gnome = {
    enable = mkEnableOption "gnome";
  };

  config = mkIf cfg.enable {
    home-manager.users.${me} = { ... }: {
      dconf.settings = { };
    };
  };
}
