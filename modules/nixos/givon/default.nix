{ config, ... }:

let
  cfg = config._.givon;
  inherit (cfg.userConfig) name;
in
{
  imports = [
    ./gnome.nix
    ./shell.nix
    ./sway.nix
    ./swaylock.nix
  ];
  config.users.users.${name} = cfg.userConfig;
}
