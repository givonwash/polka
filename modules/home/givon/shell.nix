{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf mkMerge mkOption types;
  inherit (config._.givon.userConfig) name;
  cfg = config._.givon.shell;
  anyEnvEnabled = cfg.rbenv.enable || cfg.pyenv.enable || cfg.tfenv.enable;
in
{
  options._.givon.shell = {
    enable = mkEnableOption "shell";
    rbenv.enable = mkEnableOption "rbenv";
    pyenv.enable = mkEnableOption "pyenv";
    tfenv = {
      enable = mkEnableOption "tfenv";
      package = mkOption {
        type = types.package;
        default = pkgs.callPackage ../../../pkgs/tfenv.nix {};
        description = "The tfenv package to use";
      };
      configDir = mkOption {
        type = types.str;
        default = "${config._.givon.userConfig.home}/.tfenv";
        description = "Writable directory for storing terraform versions";
      };
    };
  };

  config.home-manager.users.${name} = mkMerge [
    # Base shell config
    (mkIf cfg.enable {
      home = {
        sessionVariables.EDITOR = "nvim";
        packages = with pkgs; [
          # Core baseline utilities
          curl
          fd
          jq
          ripgrep
          tealdeer
          unzip
          yq-go
        ];
        shellAliases =
          let
            prettyGitLogFormat = "%C(red)%h %C(bold yellow)::%C(bold green)%d%C(reset) %<|(100)%s %C(italic blue)(%an, %ar)";
          in
          rec {
            ".." = "./..";
            "..." = "./../..";
            "...." = "./../../..";
            "....." = "./../../../..";
            "......" = "./../../../../..";
            c = "clear";
            cp = "cp -i";
            e = "exit";
            g = "git";
            ga = "git add";
            gaa = "git add --all";
            gb = "git branch";
            gc = "git commit --verbose";
            gca = "git commit --all --verbose";
            gco = "git checkout";
            gconf = "git config";
            gd = "git diff";
            gf = "git fetch";
            ggr = "git grep";
            gl = glp;
            glf = "git log --graph --decorate --summary --stat";
            glp = "git log --graph --format='${prettyGitLogFormat}'";
            gm = "git merge";
            gpull = "git pull";
            gpush = "git push";
            gs = "git status";
            gshow = "git show";
            gss = "git status --short";
            gsw = "git switch";
            l = "eza -la --git --time modified --time-style long-iso --group --icons";
            ll = "eza -la --git --time modified --time-style long-iso --group --icons --only-dirs";
            md = "mkdir -p";
            n = "$EDITOR";
          };
      };

      programs = {
        bat.enable = true;
        direnv = {
          enable = true;
          enableZshIntegration = true;
          nix-direnv.enable = true;
        };
        eza.enable = true;
        htop.enable = true;
        man.generateCaches = true;
        starship = {
          enable = true;
          enableZshIntegration = true;
          settings = {
            command_timeout = 1000;
            directory = {
              truncation_length = 2;
              truncate_to_repo = false;
            };
          };
        };
        zoxide = {
          enable = true;
          enableZshIntegration = true;
        };
        zsh = {
          enable = true;
          autocd = true;
          autosuggestion.enable = true;
          defaultKeymap = "viins";
          enableCompletion = true;
          syntaxHighlighting.enable = true;
        };
      };
    })

    # Enable bash when any env tool is active
    (mkIf (cfg.enable && anyEnvEnabled) {
      programs.bash.enable = true;
    })

    # rbenv
    (mkIf (cfg.enable && cfg.rbenv.enable) {
      programs.rbenv = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };
    })

    # pyenv
    (mkIf (cfg.enable && cfg.pyenv.enable) {
      programs.pyenv = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };
    })

    # tfenv
    (mkIf (cfg.enable && cfg.tfenv.enable) {
      home.packages = [ cfg.tfenv.package ];
      programs.zsh.initContent = ''
        export TFENV_CONFIG_DIR="${cfg.tfenv.configDir}"
      '';
      programs.bash.initExtra = ''
        export TFENV_CONFIG_DIR="${cfg.tfenv.configDir}"
      '';
    })
  ];
}
