{ config, ... }:

let
  cfg = config._.givon;
  inherit (cfg.userConfig) name;
in
{
  imports = [
    ./homebrew.nix
    ./linux-builder.nix
    ./shell.nix
  ];
  config.users.users.${name} = cfg.userConfig;
}
