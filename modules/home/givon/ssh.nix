{ config, ... }:

let
  inherit (config._.givon.userConfig) name;
in
{
  home-manager.users.${name} = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = true;
      addKeysToAgent = "yes";
      matchBlocks = {
        "github.com" = {
          identityFile = "~/.ssh/id_ed25519";
          identitiesOnly = true;
        };
      };
    };
  };
}
