return {
    ---@param config { disable_formatting?: boolean, extra_on_attach?: fun(client: table<string, any>, bufnr: integer): nil }
    ---@return nil
    setup = function(config)
        local client = require('config.plugins.nvim-lspconfig').client(config)

        require('typescript-tools').setup(vim.tbl_extend('keep', client, {
            settings = {
                tsserver_file_preferences = {
                    includeInlayParameterNameHints = 'all',
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
            },
        }))
    end,
}
