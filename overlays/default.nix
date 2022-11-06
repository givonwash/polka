{ pkgs }: self: super: {
  vimPlugins = super.vimPlugins // {
    obsidian-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = "obsidian-nvim";
      version = "2022-10-27";
      dependencies = with pkgs.vimPlugins; [ nvim-cmp pkgs.ripgrep telescope-nvim ];
      src = pkgs.fetchFromGitHub {
        owner = "epwalsh";
        repo = "obsidian.nvim";
        rev = "f12a439385f4337ebf3ea6f0503a69fbcdff16a9";
        sha256 = "sha256-+HqcNCV/SJOS98649xkV7n1S5GZGS7kKPeU1+9bFOXU=";
        fetchSubmodules = true;
      };
      meta.homepage = "https://github.com/epwalsh/obsidian.nvim/";
    };
  };
}
