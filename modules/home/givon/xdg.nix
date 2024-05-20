{ config, lib, ... }:

let
  inherit (config._.givon.userConfig) name;
  cfg = config._.givon.xdg;
in
{
  options._.givon.xdg.enable = lib.mkEnableOption "xdg";
  config.home-manager.users.${name}.xdg = lib.mkIf cfg.enable {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "$HOME/desktop";
      documents = "$HOME/documents";
      download = "$HOME/downloads";
      music = "$HOME/music";
      pictures = "$HOME/pictures";
      publicShare = "$HOME/public";
      templates = "$HOME/templates";
      videos = "$HOME/videos";
    };
  };
}
