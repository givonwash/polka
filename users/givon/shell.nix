{ me, ... }: { pkgs, ... }:

{
  environment.pathsToLink = [ "/share/zsh" ];

  home-manager.users.${me} = {
    home = {
      packages = with pkgs; [
        curl
        fd
        jq
        ripgrep
        tealdeer
        xdg-utils
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
          l = "exa -la --git --time modified --time-style long-iso --group --icons";
          ll = "exa -la --git --time modified --time-style long-iso --group --icons --only-dirs";
          md = "mkdir -p";
          n = "\${EDITOR}";
          o = "${pkgs.xdg-utils}/bin/xdg-open";
        };
    };

    programs = {
      bat.enable = true;
      direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
      exa.enable = true;
      htop.enable = true;
      man.generateCaches = true;
      starship = {
        enable = true;
        enableZshIntegration = true;
      };
      zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
      zsh = {
        autocd = true;
        enable = true;
        enableAutosuggestions = true;
        enableCompletion = true;
        enableSyntaxHighlighting = true;
      };
    };
  };

  programs.zsh.enable = true;

  users.users.${me}.shell = pkgs.zsh;
}
