{ config, ... }:

let
  inherit (config._.givon.userConfig) name;
in
{
  home-manager.users.${name} = {
    programs.ssh = {
      enable = true;
    };
  };
}
