{ config, lib, me, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption optional types;

  cfg = config._.${me}.neovim;
in
{
  options._.${me}.neovim = {
    enable = mkEnableOption "neovim";
    obsidian-nvim = {
      enable = mkEnableOption "obsidian-nvim";
      vault = mkOption rec {
        type = types.str;
        example = "~/repos/splatter";
        default = example;
        description = ''
          Location of Obsidian Vault
        '';
      };
    };
  };

  config = {
    home-manager.users.${me} = rec {
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
        plugins = with pkgs.vimPlugins;
          [
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
            {
              config = ''
                require("config.plugins.luasnip").setup()
              '';
              plugin = luasnip;
              type = "lua";
            }
            {
              config = ''
                require('config.plugins.null-ls-nvim').setup {
                    code_actions = { 'gitsigns' },
                    formatting = { 'black', 'isort', 'prettier', 'stylua', }
                }
              '';
              plugin = none-ls-nvim;
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
                                python = { analysis = { typeCheckingMode = 'strict' } },
                            },
                        },
                    },
                    { name = 'nil_ls' },
                    { name = 'lua_ls', config = { disable_formatting = true } },
                    { name = 'terraformls' },
                    { name = 'tsserver' },
                    {
                        name = 'cssls',
                        opts = { cmd = { 'css-languageserver', '--stdio' } },
                        config = { disable_formatting = true }
                    },
                    {
                        name = 'html',
                        opts = { cmd = { 'html-languageserver', '--stdio' } },
                        config = { disable_formatting = true }
                    },
                    { name = 'bashls' },
                    { name = 'ruby_ls' }
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
              plugin = nvim-treesitter.withAllGrammars;
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
            {
              config = ''
                require("config.plugins.true-zen-nvim").setup()
              '';
              plugin = true-zen-nvim;
              type = "lua";
            }
            vim-surround
          ] ++ (optional cfg.obsidian-nvim.enable {
            config = ''
              require("config.plugins.obsidian-nvim").setup {
                  vault = "${cfg.obsidian-nvim.vault}"
              }
            '';
            plugin = obsidian-nvim;
            type = "lua";
          });
        extraPackages = with pkgs; [
          black
          fd
          nil
          nodePackages.bash-language-server
          nodePackages.prettier
          nodePackages.typescript-language-server
          nodePackages.vscode-css-languageserver-bin
          nodePackages.vscode-html-languageserver-bin
          pyright
          python310Packages.isort
          ripgrep
          rust-analyzer
          stylua
          sumneko-lua-language-server
          terraform-ls
        ];
      };
    };
  };
}
