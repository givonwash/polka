{ lib, config, ... }:

let
  cfg = config._.pera.homebrew;
in
{
  options._.pera.homebrew.enable = lib.mkEnableOption "homebrew";

  config.homebrew = lib.mkIf cfg.enable {
    enable = true;
    onActivation.cleanup = "zap";
  };
}
