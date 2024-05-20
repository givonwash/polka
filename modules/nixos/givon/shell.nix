{ pkgs, lib, config, ... }:
let
  inherit (config._.givon.userConfig) name;
  cfg = config._.givon.shell;
in
lib.mkIf cfg.enable {
  environment.pathsToLink = [ "/share/zsh" ];
  programs.zsh.enable = true;
  users.users.${name}.shell = pkgs.zsh;

  home-manager.users.${name}.home = {
    packages = with pkgs; [
      strace
      xdg-utils
    ] ++ lib.optional (config.virtualisation.docker.enable) docker-compose;
    shellAliases.o = "${pkgs.xdg-utils}/bin/xdg-open";
  };
}
