self: super: {
  vimPlugins = super.vimPlugins // {
    obsidian-nvim = super.vimUtils.buildVimPlugin {
      pname = "obsidian-nvim";
      version = "v3.7.8";
      dependencies = with super.vimPlugins; [ nvim-cmp super.ripgrep telescope-nvim ];
      src = super.fetchFromGitHub {
        owner = "epwalsh";
        repo = "obsidian.nvim";
        rev = "9644aca08334bb3f6fbeeccacc9e4dbb5855577e";
        sha256 = "sha256-D2uFbB+9BrEMoKV73MGlK7mTrh2wpRpkg3CrVPYxL2c=";
      };
      meta.homepage = "https://github.com/epwalsh/obsidian.nvim/";
    };
  };
}
