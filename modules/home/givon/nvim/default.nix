{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkOption optional types;
  inherit (config._.givon.userConfig) name;

  cfg = config._.givon.neovim;
  hmCfg = config.home-manager.users.${name}.programs.neovim;
in
{
  options._.givon.neovim.enable = mkEnableOption "neovim";

  config.home-manager.users.${name} = {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      package = pkgs.neovim-unwrapped;
      plugins = with pkgs.vimPlugins;
        [
          SchemaStore-nvim
          bufferline-nvim
          catppuccin-nvim
          cmp-buffer
          cmp-cmdline
          cmp-emoji
          cmp-nvim-lsp
          cmp-path
          cmp_luasnip
          fidget-nvim
          friendly-snippets
          gitsigns-nvim
          kommentary
          lazy-nvim
          lualine-nvim
          luasnip
          none-ls-nvim
          nvim-autopairs
          nvim-cmp
          nvim-colorizer-lua
          nvim-lspconfig
          nvim-metals
          nvim-notify
          nvim-tree-lua
          nvim-treesitter-context
          nvim-treesitter.withAllGrammars
          nvim-web-devicons
          plenary-nvim
          (project-nvim.overrideAttrs {
            src = pkgs.fetchFromGitHub {
              owner = "DrKJeff16";
              repo = "project.nvim";
              rev = "d20d5fb6cd4a7b21fb9a74d96764e4739abc3ad8";
              sha256 = "1kbvhzv1nv87jqnwckvgj6mimy27bcx1vlbrp0farv39ylbk58kb";
            };
          })
          render-markdown-nvim
          rust-tools-nvim
          telescope-nvim
          trouble-nvim
          true-zen-nvim
          typescript-tools-nvim
          vim-surround
        ];
      extraLuaConfig = ''
        vim.g.mapleader = " "
        vim.g.maplocalleader = ","
        require("config").setup()
        require("lazy").setup {
            dev = {
                path = '${pkgs.vimUtils.packDir hmCfg.finalPackage.passthru.packpathDirs}/pack/myNeovimPackages/start',
                patterns = {""}
            },
            install = {
                missing = false
            },
            performance = {
                reset_packpath = false,
                rtp = { reset = false }
            },
            spec = {
                { import = "config/plugins" }
            }
        }
      '';
      extraPackages = with pkgs; [
        fd
        jinja-lsp
        nil
        nixpkgs-fmt
        nodePackages.bash-language-server
        nodePackages.prettier
        nodePackages.typescript-language-server
        nodePackages.vscode-langservers-extracted
        pyright
        ripgrep
        ruff
        rust-analyzer
        stylua
        sqlfluff
        sumneko-lua-language-server
        terraform-ls
        yaml-language-server
      ];
    };
    xdg.configFile."nvim/lua" = {
      recursive = true;
      source = ./lua;
    };
  };
}
