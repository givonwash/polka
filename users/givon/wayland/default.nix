{ me, pkgs, ... }:

{
  imports = [
    ./gnome.nix
    ./sway
  ];

  home-manager.users.${me} = {
    home.packages = with pkgs; [ wl-clipboard ];
  };
}
