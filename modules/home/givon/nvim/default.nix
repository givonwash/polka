{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkOption optional types;
  inherit (config._.givon.userConfig) name;

  cfg = config._.givon.neovim;
in
{
  options._.givon.neovim = {
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

  config.home-manager.users.${name} = {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
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
          cmp_luasnip
          cmp-nvim-lsp
          cmp-path
          {
            config = ''
              require("config.plugins.fidget-nvim").setup()
            '';
            plugin = fidget-nvim;
            type = "lua";
          }
          friendly-snippets
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
                  diagnostics = { 'sqlfluff' },
                  formatting = { 'black', 'isort', 'prettier', 'stylua', 'sqlfluff' }
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
              require("config.plugins.nvim-metals").setup()
            '';
            plugin = nvim-metals;
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
                  {
                      name = 'nil_ls',
                      opts = {
                          settings = {
                              ['nil'] = { formatting = { command = { 'nixpkgs-fmt' } } }
                          },
                      }
                  },
                  { name = 'lua_ls', config = { disable_formatting = true } },
                  { name = 'terraformls' },
                  { name = 'cssls', config = { disable_formatting = true } },
                  { name = 'html', config = { disable_formatting = true } },
                  { name = 'eslint' },
                  {
                      name = 'jsonls',
                      config = { disable_formatting = true },
                      opts = {
                          settings = {
                              json = {
                                  schemas = require('schemastore').json.schemas(),
                                  validate = { enable = true },
                              }
                          }
                      }
                  },
                  { name = 'bashls' },
                  { name = 'solargraph', { config = { disable_formatting = true } } },
                  {
                      name = 'yamlls',
                      config = { disable_formatting = true },
                      opts = {
                          settings = {
                              yaml = {
                                  schemaStore = { enable = false, url = "", },
                                  schemas = require('schemastore').yaml.schemas()
                              }
                          }
                      }
                  }
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
          {
            config = ''
              require("config.plugins.nvim-treesitter-context").setup()
            '';
            plugin = nvim-treesitter-context;
            type = "lua";
          }
          nvim-web-devicons
          SchemaStore-nvim
          plenary-nvim
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
          {
            config = ''
              require("config.plugins.typescript-tools-nvim").setup { disable_formatting = true }
            '';
            plugin = typescript-tools-nvim;
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
        isort
        nil
        nixpkgs-fmt
        nodePackages.bash-language-server
        nodePackages.prettier
        nodePackages.typescript-language-server
        nodePackages.vscode-langservers-extracted
        pyright
        ripgrep
        rust-analyzer
        stylua
        sqlfluff
        sumneko-lua-language-server
        terraform-ls
        yaml-language-server
      ];
    };
  };
}
