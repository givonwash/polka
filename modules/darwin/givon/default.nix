{ config, ... }:

let
  cfg = config._.givon;
  inherit (cfg.userConfig) name;
in
{
  imports = [
    ./shell.nix
  ];
  config.users.users.${name} = cfg.userConfig;
}
