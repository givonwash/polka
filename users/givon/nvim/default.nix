{ me, ... }: { ... }:

{
  home-manager.users.${me} = { pkgs, ... }: rec {
    home = {
      sessionVariables = {
        EDITOR = "nvim";
      };
    };

    programs.neovim = {
      enable = true;
      extraConfig = ''
        let mapleader = " "
        let maplocalleader = ","

        lua package.path = package.path .. ";${./lua}/?/init.lua;${./lua}/?.lua"
        lua require("config").setup()
      '';
      package = pkgs.neovim-unwrapped;
      plugins = with pkgs.vimPlugins; [
        {
          config = ''
            require("config.plugins.bufferline-nvim").setup()
          '';
          plugin = bufferline-nvim;
          type = "lua";
        }
        {
          config = ''
            require("config.plugins.catppuccin-nvim").setup()
          '';
          plugin = catppuccin-nvim;
          type = "lua";
        }
        cmp-buffer
        cmp-cmdline
        cmp-emoji
        cmp-nvim-lsp
        cmp-path
        {
          config = ''
            require("config.plugins.gitsigns-nvim").setup()
          '';
          plugin = gitsigns-nvim;
          type = "lua";
        }
        kommentary
        {
          config = ''
            require("config.plugins.lualine-nvim").setup()
          '';
          plugin = lualine-nvim;
          type = "lua";
        }
        luasnip
        {
          config = ''
            require('config.plugins.null-ls-nvim').setup {
                code_actions = { 'gitsigns' },
                formatting = { 'black', 'isort', 'prettier', 'stylua', }
            }
          '';
          plugin = null-ls-nvim;
          type = "lua";
        }
        {
          config = ''
            require("config.plugins.nvim-autopairs").setup()
          '';
          plugin = nvim-autopairs;
          type = "lua";
        }
        {
          config = ''
            require("config.plugins.nvim-lspconfig").setup {
                {
                    name = 'pyright',
                    opts = {
                        settings = {
                            python = { analysis = { { typeCheckingMode = 'strict' } } },
                        },
                    },
                },
                { name = 'rnix' },
                { name = 'sumneko_lua', config = { disable_formatting = true } },
            }
          '';
          plugin = nvim-lspconfig;
          type = "lua";
        }
        {
          config = ''
            require("config.plugins.nvim-cmp").setup()
          '';
          plugin = nvim-cmp;
          type = "lua";
        }
        {
          config = ''
            require("config.plugins.nvim-colorizer-lua").setup()
          '';
          plugin = nvim-colorizer-lua;
          type = "lua";
        }
        {
          config = ''
            require("config.plugins.nvim-notify").setup()
          '';
          plugin = nvim-notify;
          type = "lua";
        }
        {
          config = ''
            require("config.plugins.nvim-tree-lua").setup()
          '';
          plugin = nvim-tree-lua;
          type = "lua";
        }
        {
          config = ''
            require("config.plugins.nvim-treesitter").setup()
          '';
          plugin = (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars));
          type = "lua";
        }
        nvim-web-devicons
        {
          config = ''
            require("config.plugins.project-nvim").setup()
          '';
          plugin = project-nvim;
          type = "lua";
        }
        {
          config = ''
            require("config.plugins.rust-tools-nvim").setup()
          '';
          plugin = rust-tools-nvim;
          type = "lua";
        }
        {
          config = ''
            require("config.plugins.telescope-nvim").setup()
          '';
          plugin = telescope-nvim;
          type = "lua";
        }
        {
          config = ''
            require("config.plugins.trouble-nvim").setup()
          '';
          plugin = trouble-nvim;
          type = "lua";
        }
        vim-surround
      ];
      extraPackages = with pkgs; [
        black
        fd
        nodePackages.prettier
        pyright
        python310Packages.isort
        ripgrep
        rnix-lsp
        rust-analyzer
        stylua
        sumneko-lua-language-server
      ];
    };
  };
}
