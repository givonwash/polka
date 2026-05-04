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

      select = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Enable selector command for interactive worktree switching";
        };

        command = mkOption {
          type = types.str;
          default = "gwt";
          description = "Name of the selector command";
        };
      };

      sync = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Enable sync command for cleaning up merged worktrees";
        };

        command = mkOption {
          type = types.str;
          default = "gwt-sync";
          description = "Name of the sync command";
        };

        deleteBranch = mkOption {
          type = types.bool;
          default = true;
          description = "Also delete the local branch after removing the worktree";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${name} = { config, ... }:
      let
        inherit (cfg.wt) select sync;

        worktreeSelectorFunction = ''
          ${select.command}() {
            selected=$(${cfg.wt.package}/bin/git-wt | ${pkgs.gnused}/bin/sed -En '/^[[:space:]]*\*/!p' | ${pkgs.fzf}/bin/fzf)
            if [[ -n "$selected" ]]; then
              path=$(${pkgs.gawk}/bin/awk '{print $1}' <<< "$selected")
              echo "Switching to worktree at $path"
              cd "$path"
            fi
          }
        '';

        worktreeSyncFunction = ''
          ${sync.command}() {
            local delete_branch="${if sync.deleteBranch then "true" else "false"}"

            # Parse flags
            while [[ $# -gt 0 ]]; do
              case "$1" in
                --keep-branch) delete_branch="false"; shift ;;
                --delete-branch) delete_branch="true"; shift ;;
                -h|--help)
                  echo "Usage: ${sync.command} [OPTIONS]"
                  echo "  --keep-branch    Don't delete local branch"
                  echo "  --delete-branch  Delete local branch (default: ${if sync.deleteBranch then "yes" else "no"})"
                  return 0 ;;
                *) echo "Unknown: $1"; return 1 ;;
              esac
            done

            if ! git rev-parse --git-dir > /dev/null 2>&1; then
              echo "Error: Not in a git repository"; return 1
            fi

            if ! ${pkgs.gh}/bin/gh auth status > /dev/null 2>&1; then
              echo "Error: gh CLI is not authenticated. Run 'gh auth login' first."; return 1
            fi

            # Parse git-wt output (skip header, handle * prefix for current worktree)
            ${cfg.wt.package}/bin/git-wt \
              | ${pkgs.gnused}/bin/sed -En '/^[[:space:]]*\*/!p' \
              | ${pkgs.gawk}/bin/awk 'NR > 1 {print $1, $2}' \
              | while read -r wt_path branch; do

              echo "Checking $branch..."
              local pr_state
              pr_state=$(${pkgs.gh}/bin/gh pr list --head "$branch" --state all --limit 1 --json state --jq '.[0].state // empty' 2>/dev/null)

              if [[ -z "$pr_state" ]]; then
                echo "No PR found for $branch, skipping."
                continue
              fi

              if [[ "$pr_state" == "MERGED" || "$pr_state" == "CLOSED" ]]; then
                echo "Removing worktree ($pr_state): $wt_path ($branch)"
                if [[ "$delete_branch" == "true" ]]; then
                  ${cfg.wt.package}/bin/git-wt -D "$branch"
                else
                  git worktree remove "$wt_path"
                fi
              else
                echo "PR for $branch is $pr_state, skipping."
              fi
            done
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
        ${optionalString cfg.wt.select.enable worktreeSelectorFunction}
        ${optionalString cfg.wt.sync.enable worktreeSyncFunction}
      '';

      programs.bash.initExtra = mkIf (cfg.wt.enable && cfg.wt.enableBashIntegration) ''
        # Initialize git-wt shell integration
        eval "$(${cfg.wt.package}/bin/git-wt --init bash${optionalString cfg.wt.nocd " --nocd"})"
        ${optionalString cfg.wt.select.enable worktreeSelectorFunction}
        ${optionalString cfg.wt.sync.enable worktreeSyncFunction}
      '';
    };
  };
}
