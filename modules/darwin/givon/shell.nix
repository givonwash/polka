{ pkgs, lib, config, ... }:
let
  inherit (config._.givon.userConfig) name;
  cfg = config._.givon.shell;
in
lib.mkIf cfg.enable {
  environment.pathsToLink = [ "/share/zsh" ];
  programs.zsh.enable = true;
  users.users.${name}.shell = pkgs.zsh;
}
