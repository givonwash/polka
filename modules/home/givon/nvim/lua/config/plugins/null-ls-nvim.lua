return {
    {
        'nvimtools/none-ls.nvim',
        opts = {
            on_attach = require('lib.plugins.nvim-lspconfig').client({}).on_attach,
        },
        config = function(_, opts)
            local null_ls = require 'null-ls'
            null_ls.setup(vim.tbl_extend('keep', opts, {
                sources = {
                    null_ls.builtins.code_actions.gitsigns,
                    null_ls.builtins.formatting.prettier,
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.sqlfluff,
                },
            }))
        end,
    },
}
