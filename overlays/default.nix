self: super: {
  vimPlugins = super.vimPlugins // {
    obsidian-nvim = super.vimUtils.buildVimPluginFrom2Nix {
      pname = "obsidian-nvim";
      version = "2022-10-27";
      dependencies = with super.vimPlugins; [ nvim-cmp super.ripgrep telescope-nvim ];
      src = super.fetchFromGitHub {
        owner = "epwalsh";
        repo = "obsidian.nvim";
        rev = "5cb5a10d6e665065e0d1ba35d78c108fedaafbcd";
        sha256 = "sha256-5JbCGUbrV6C0xzdEGSspc5vxH2hENlf7oAPrRQ1Z/2Y=";
      };
      meta.homepage = "https://github.com/epwalsh/obsidian.nvim/";
    };
  };
}
