{ me, utils, ... }: { config, lib, ... }:

let
  cfg = config._.${me};
in
{
  imports = [
    (import ./sway { inherit me utils; })
  ];

  home-manager.users.${me} = lib.mkIf cfg.sway.enable {
    home.sessionVariables.MOZ_ENABLE_WAYLAND = 1;
    home.sessionVariables.MOZ_DBUS_REMOTE = 1;
  };
}
