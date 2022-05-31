{ me, ... }: { config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption types;
  cfg = config._.${me}.git;
  nvimEnabled = config.home-manager.users.${me}.programs.neovim.enable;
in
{
  options._.${me}.git = {
    email = mkOption {
      type = types.str;
      example = "myemail@gmail.com";
      description = ''
        Email to use for git user
      '';
    };
    userName = mkOption {
      type = types.str;
      example = "myuser";
      description = ''
        Username to use for git user
      '';
    };
  };

  config = {
    home-manager.users.${me} = { ... }: {
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
        userEmail = cfg.email;
        userName = cfg.userName;
      };
    };
  };
}
