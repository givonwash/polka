return {
    ---@return nil
    setup = function()
        require('rust-tools').setup {
            server = vim.tbl_extend(
                'keep',
                require('config.plugins.nvim-lspconfig').client,
                { settings = { ['rust-analyzer'] = { checkOnSave = 'clippy' } } }
            ),
        }
    end,
}
