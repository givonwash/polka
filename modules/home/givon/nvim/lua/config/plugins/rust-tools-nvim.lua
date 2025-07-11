return {
    {
        'simrat39/rust-tools.nvim',
        ft = { 'rust' },
        opts = {
            server = vim.tbl_extend(
                'keep',
                require('lib.plugins.nvim-lspconfig').client {},
                { settings = { ['rust-analyzer'] = { checkOnSave = 'clippy' } } }
            ),
        },
    },
}
