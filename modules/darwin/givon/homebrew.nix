{ lib, config, ... }:

let
  cfg = config._.givon.homebrew;
  wezCfg = config._.givon.wezterm;
in
{
  options._.givon = {
    homebrew.enable = lib.mkEnableOption "homebrew";
    wezterm.enableHomebrewInstallation = lib.mkOption rec {
      description = "Enable installation of wezterm by Homebrew";
      example = default;
      default = false;
      type = lib.types.bool;
    };
  };
  config.homebrew.casks = lib.optional (cfg.enable && wezCfg.enableHomebrewInstallation) "wezterm";
}
