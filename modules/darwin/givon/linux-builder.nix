{ config ,lib, ... }:
let
  cfg = config._.givon.linux-builder;
in {
  options._.givon.linux-builder.enable = lib.mkEnableOption "linux-builder";
  config.nix = lib.mkIf cfg.enable {
    linux-builder = {
      enable = true;
      maxJobs = 6;
      config = {
        virtualisation.cores = 3;
      };
    };
    settings = {
      trusted-users = [ "@admin" "givon" ];
      extra-trusted-users = [ "@admin" "givon" ];
    };
  };
}
