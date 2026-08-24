{ config, ... }:

let
  inherit (config._.givon.userConfig) name;
in
{
  home-manager.users.${name} = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "*" = {
          AddKeysToAgent = "yes";
          Compression = false;
          ControlMaster = "no";
          ControlPath = "~/.ssh/master-%r@%n:%p";
          ControlPersist = "no";
          ForwardAgent = false;
          HashKnownHosts = false;
          ServerAliveCountMax = 3;
          ServerAliveInterval = 0;
          UserKnownHostsFile = "~/.ssh/known_hosts";
        };
        "github.com" = {
          IdentitiesOnly = true;
          IdentityFile = "~/.ssh/id_ed25519";
        };
      };
    };
  };
}
