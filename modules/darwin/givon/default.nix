{ config, ... }:

let
  cfg = config._.givon;
  inherit (cfg.userConfig) name;
in
{
  imports = [
    ./homebrew.nix
    ./shell.nix
  ];
  config.users.users.${name} = cfg.userConfig;
}
