{ config, lib, pkgs, ... }:

let
  inherit (config._.givon.userConfig) name;
  cfg = config._.givon.shell;
in
{
  options._.givon.shell.enable = lib.mkEnableOption "shell";
  config.home-manager.users.${name} = lib.mkIf cfg.enable {
    home = {
      sessionVariables.EDITOR = "nvim";
      packages = with pkgs; [
        awscli2
        claude-code
        google-cloud-sdk
        graphite-cli
        curl
        fd
        python312Packages.ipython
        jq
        ripgrep
        tealdeer
        unzip
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
          n = "\${EDITOR}";
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
  };
}
