{ me, ... }: { pkgs, ... }:

{
  environment.pathsToLink = [ "/share/zsh" ];

  home-manager.users.${me} = { pkgs, ... }: {
    home = {
      packages = with pkgs; [
        curl
        fd
        jq
        ripgrep
        tealdeer
        xdg-utils
      ];
      shellAliases = {
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
        gl = "git log --graph --decorate --summary --stat";
        gll = "git log --graph --decorate --all --summary --stat";
        gm = "git merge";
        gpull = "git pull";
        gpush = "git push";
        gs = "git status";
        gshow = "git show";
        gss = "git stauts --short";
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
