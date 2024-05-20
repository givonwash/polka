{ pkgs, config, lib, ... }:

let
  inherit (config._.givon.userConfig) name;
  cfg = config._.givon.wayland;
in
{
  imports = [
    ./gnome.nix
    ./sway
  ];

  options._.givon.wayland.enable = lib.mkEnableOption "wayland";

  config.home-manager.users.${name} = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ wl-clipboard ];
  };
}
