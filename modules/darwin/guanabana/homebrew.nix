{ lib, config, ... }:

let
  cfg = config._.guanabana.homebrew;
in
{
  options._.guanabana.homebrew.enable = lib.mkEnableOption "homebrew";

  config.homebrew = lib.mkIf cfg.enable {
    enable = true;
    onActivation.cleanup = "zap";
  };
}
