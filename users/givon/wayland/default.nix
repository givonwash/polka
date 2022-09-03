{ me, utils, ... }: { ... }:

{
  imports = [
    (import ./gnome.nix { inherit me utils; })
    (import ./sway { inherit me utils; })
  ];

  home-manager.users.${me} = { pkgs, ... }: {
    home.packages = with pkgs; [ wl-clipboard ];
  };
}
