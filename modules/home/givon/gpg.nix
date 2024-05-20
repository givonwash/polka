{ lib, config, ... }:
let
  inherit (config._.givon.userConfig) name;
  cfg = config._.givon.gpg;
in
{
  options._.givon.gpg.enable = lib.mkEnableOption "gpg";
  config.home-manager.users.${name} = lib.mkIf cfg.enable {
    programs.gpg = {
      enable = true;
      mutableKeys = false;
      mutableTrust = false;
    };
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      enableZshIntegration = true;
    };
  };
}
