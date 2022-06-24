{ me, utils, ... }: { pkgs, ... }:

{
  imports = [
    (import ./sway { inherit me utils; })
  ];

  home-manager.users.${me} = { config, pkgs, ... }: {
    home.sessionVariables.MOZ_ENABLE_WAYLAND = 1;
    home.sessionVariables.MOZ_DBUS_REMOTE = 1;
  };
}
