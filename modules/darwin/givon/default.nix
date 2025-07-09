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
  config = {
    ids.gids.nixbld = 350;
    users.users.${name} = cfg.userConfig;
  };
}
