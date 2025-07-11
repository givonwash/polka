return {
    {
        'pmizio/typescript-tools.nvim',
        opts = vim.tbl_extend(
            'keep',
            require('lib.plugins.nvim-lspconfig').client { disable_formatting = true },
            {
                settings = {
                    tsserver_file_preferences = {
                        includeInlayParameterNameHints = 'all',
                        includeInlayVariableTypeHints = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true,
                    },
                },
            }
        ),
    },
}
