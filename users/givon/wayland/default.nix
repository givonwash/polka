{ me, utils, ... }: { pkgs, ... }:

{
  imports = [
    (import ./gnome.nix { inherit me utils; })
    (import ./sway { inherit me utils; })
  ];

  home-manager.users.${me} = {
    home.packages = with pkgs; [ wl-clipboard ];
  };
}
