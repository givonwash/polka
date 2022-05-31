{ me, ... }: { ... }:

{
  home-manager.users.${me} = { pkgs, ... }: rec {
    home = {
      packages = with pkgs; [
        black
        nodePackages.prettier
        python310Packages.isort
        stylua
      ];
      sessionVariables = {
        EDITOR = "${programs.neovim.package}/bin/nvim";
      };
    };

    programs.neovim = {
      enable = true;
      extraConfig = ''
        let mapleader = " "
        let maplocalleader = ","

        lua package.path = package.path .. ";${./lua}/?/init.lua;${./lua}/?.lua"
        lua require("core").setup()
      '';
      package = pkgs.neovim-unwrapped;
      plugins = with pkgs.vimPlugins; [
        {
          config = ''
            require("plugins.bufferline-nvim").setup()
          '';
          plugin = bufferline-nvim;
          type = "lua";
        }
        {
          config = ''
            require("plugins.catppuccin-nvim").setup()
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
            require("plugins.gitsigns-nvim").setup()
          '';
          plugin = gitsigns-nvim;
          type = "lua";
        }
        kommentary
        {
          config = ''
            require("plugins.lualine-nvim").setup()
          '';
          plugin = lualine-nvim;
          type = "lua";
        }
        luasnip
        {
          config = ''
            require("plugins.null-ls-nvim").setup {
                code_actions = {
                    gitsigns = nil,
                },
                formatting = {
                    black = {
                        command = "${pkgs.black}/bin/black",
                    },
                    isort = {
                        command = "${pkgs.python310Packages.isort}/bin/isort",
                    },
                    prettier = {
                        command = "${pkgs.nodePackages.prettier}/bin/prettier",
                    },
                    stylua = {
                        command = "${pkgs.stylua}/bin/stylua",
                    },
                }
            }
          '';
          plugin = null-ls-nvim;
          type = "lua";
        }
        {
          config = ''
            require("plugins.nvim-autopairs").setup()
          '';
          plugin = nvim-autopairs;
          type = "lua";
        }
        {
          config = ''
            require("plugins.nvim-lspconfig").setup {
                {
                    name = "pyright",
                    cmd = { "${pkgs.pyright}/bin/pyright-languageserver", "--stdio" }
                },
                {
                    name = "rnix",
                    cmd = { "${pkgs.rnix-lsp}/bin/rnix-lsp" }
                },
                {
                    name = "sumneko_lua",
                    cmd = { "${pkgs.sumneko-lua-language-server}/bin/lua-language-server" }
                }
            }
          '';
          plugin = nvim-lspconfig;
          type = "lua";
        }
        {
          config = ''
            require("plugins.nvim-cmp").setup()
          '';
          plugin = nvim-cmp;
          type = "lua";
        }
        {
          config = ''
            require("plugins.nvim-colorizer-lua").setup()
          '';
          plugin = nvim-colorizer-lua;
          type = "lua";
        }
        {
          config = ''
            require("plugins.nvim-notify").setup()
          '';
          plugin = nvim-notify;
          type = "lua";
        }
        {
          config = ''
            require("plugins.nvim-tree-lua").setup()
          '';
          plugin = nvim-tree-lua;
          type = "lua";
        }
        {
          config = ''
            require("plugins.nvim-treesitter").setup()
          '';
          plugin = (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars));
          type = "lua";
        }
        nvim-web-devicons
        {
          config = ''
            require("plugins.project-nvim").setup()
          '';
          plugin = project-nvim;
          type = "lua";
        }
        {
          config = ''
            require("plugins.rust-tools-nvim").setup()
          '';
          plugin = rust-tools-nvim;
          type = "lua";
        }
        {
          config = ''
            require("plugins.telescope-nvim").setup()
          '';
          plugin = telescope-nvim;
          type = "lua";
        }
        {
          config = ''
            require("plugins.trouble-nvim").setup()
          '';
          plugin = trouble-nvim;
          type = "lua";
        }
        vim-surround
      ];
      extraPackages = with pkgs; [
        fd
        pyright
        ripgrep
        rnix-lsp
        rust-analyzer
        sumneko-lua-language-server
      ];
    };
  };
}
