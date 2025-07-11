return {
    {
        'neovim/nvim-lspconfig',
        opts = {
            servers = {
                {
                    name = 'pyright',
                    opts = {
                        settings = {
                            pyright = { disableOrganizeImports = true },
                            python = { analysis = { typeCheckingMode = 'strict' } },
                        },
                    },
                },
                { name = 'ruff' },
                {
                    name = 'nil_ls',
                    opts = {
                        settings = {
                            ['nil'] = { formatting = { command = { 'nixpkgs-fmt' } } },
                        },
                    },
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
                            },
                        },
                    },
                },
                { name = 'bashls' },
                { name = 'solargraph', { config = { disable_formatting = true } } },
                {
                    name = 'yamlls',
                    config = { disable_formatting = true },
                    opts = {
                        settings = {
                            yaml = {
                                schemaStore = { enable = false, url = '' },
                                schemas = require('schemastore').yaml.schemas(),
                            },
                        },
                    },
                },
                { name = 'jinja_lsp', opts = { filetypes = { 'jinja', 'sql' } } },
            },
        },
        config = function(_, opts)
            local liblsp = require 'lib.plugins.nvim-lspconfig'
            for _, server in pairs(opts.servers) do
                require('lspconfig')[server.name].setup(
                    vim.tbl_extend('keep', server.opts or {}, liblsp.client(server.config or {}))
                )
            end
        end,
    },
}
