{ config, lib, me, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config._.${me}.git;
  nvimEnabled = config.home-manager.users.${me}.programs.neovim.enable;
in
{
  options._.${me}.git = {
    enable = mkEnableOption "git";
    email = mkOption rec {
      type = types.str;
      example = default;
      default = "givonwash@gmail.com";
      description = ''
        Email to use for git user
      '';
    };
    userName = mkOption rec {
      type = types.str;
      example = default;
      default = "givonwash";
      description = ''
        Username to use for git user
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${me} = {
      programs.git = {
        enable = true;
        delta = {
          enable = true;
          options = {
            navigate = true;
            hyperlinks = true;
            line-numbers = true;
          };
        };
        extraConfig =
          let
            nvimdiff = mkIf nvimEnabled { tool = "nvimdiff"; };
          in
          {
            core = { pager = "delta"; } // mkIf nvimEnabled { editor = "nvim"; };
            diff = { algorithm = "histogram"; colorMoved = "default"; } // nvimdiff;
            init = { defaultBranch = "main"; };
            merge = { conflictStyle = "diff3"; } // nvimdiff;
            pull = { rebase = true; };
          };
        ignores = [ ".direnv" ];
        userEmail = cfg.email;
        userName = cfg.userName;
      };
    };
  };
}
