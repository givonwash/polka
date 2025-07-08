self: super: {
  vimPlugins = super.vimPlugins // {
    dbtpal = super.vimUtils.buildVimPlugin {
      pname = "dbtpal";
      version = "nightly";
      dependencies = with super.vimPlugins; [ plenary-nvim telescope-nvim ];
      src = super.fetchFromGitHub {
        owner = "PedramNavid";
        repo = "dbtpal";
        rev = "981eab51609362712c64e3cf3fb773fe11f859b9";
        sha256 = "sha256-jxyD1knlfCqENotkSvzHQr3+vVOiOD735umHwRWuCpY=";
      };
    };
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
