{ pkgs }: self: super: {
  vimPlugins = super.vimPlugins // {
    obsidian-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = "obsidian-nvim";
      version = "2022-10-27";
      dependencies = with pkgs.vimPlugins; [ nvim-cmp pkgs.ripgrep telescope-nvim ];
      src = pkgs.fetchFromGitHub {
        owner = "epwalsh";
        repo = "obsidian.nvim";
        rev = "30f45ae3ef78b67d9eae16adfbaaf86089bd8855";
        sha256 = "sha256-pMYvtNEYoVFaWlj35F1rDlfJkNY4y4S62RNpHBNBgto=";
        fetchSubmodules = true;
      };
      meta.homepage = "https://github.com/epwalsh/obsidian.nvim/";
    };
  };
}
