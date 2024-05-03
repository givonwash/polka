{ pkgs, ... }:

{
  imports = [
    ./gnome.nix
    ./sway
  ];

  home-manager.users.givon = {
    home.packages = with pkgs; [ wl-clipboard ];
  };
}
