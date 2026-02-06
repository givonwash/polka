{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption optionalString types;
  inherit (config._.givon.userConfig) name;
  cfg = config._.givon.git;
in
{
  options._.givon.git = {
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

    wt = {
      enable = mkEnableOption "git-wt";

      package = mkOption {
        type = types.package;
        default = pkgs.git-wt;
        description = "The git-wt package to use";
      };

      enableZshIntegration = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Zsh integration for git-wt";
      };

      enableBashIntegration = mkOption {
        type = types.bool;
        default = false;
        description = "Enable Bash integration for git-wt (experimental)";
      };

      nocd = mkOption {
        type = types.bool;
        default = false;
        description = "Disable automatic directory changing";
      };

      enableFuzzySelector = mkOption {
        type = types.bool;
        default = true;
        description = "Enable fuzzy selector command for interactive worktree switching";
      };

      fuzzySelectorCommand = mkOption {
        type = types.str;
        default = "gwt";
        description = "Name of the fuzzy selector command";
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${name} = { config, ... }:
      let
        inherit (cfg.wt) fuzzySelectorCommand;

        fuzzyWorktreeSelector = ''
          ${fuzzySelectorCommand}() {
            selected=$(${cfg.wt.package}/bin/git-wt | ${pkgs.fzf}/bin/fzf)
            if [[ -n "$selected" ]]; then
              path=$(echo "$selected" | ${pkgs.gawk}/bin/awk '{print $1}')
              echo "Switching to worktree at $path"
              cd "$path"
            fi
          }
        '';
      in {
      home.packages = mkIf cfg.wt.enable [ cfg.wt.package ];

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
        extraConfig = {
          core = { editor = "nvim"; };
          diff = { algorithm = "histogram"; colorMoved = "default"; tool = "nvimdiff"; };
          init = { defaultBranch = "main"; };
          merge = { conflictStyle = "diff3"; tool = "nvimdiff"; };
          pull = { rebase = true; };
        };
        ignores = [ ".direnv" ];
        userEmail = cfg.email;
        userName = cfg.userName;
      };

      programs.zsh.initExtra = mkIf (cfg.wt.enable && cfg.wt.enableZshIntegration) ''
        # Initialize git-wt shell integration
        eval "$(${cfg.wt.package}/bin/git-wt --init zsh${optionalString cfg.wt.nocd " --nocd"})"
        ${optionalString cfg.wt.enableFuzzySelector fuzzyWorktreeSelector}
      '';

      programs.bash.initExtra = mkIf (cfg.wt.enable && cfg.wt.enableBashIntegration) ''
        # Initialize git-wt shell integration
        eval "$(${cfg.wt.package}/bin/git-wt --init bash${optionalString cfg.wt.nocd " --nocd"})"
        ${optionalString cfg.wt.enableFuzzySelector fuzzyWorktreeSelector}
      '';
    };
  };
}
