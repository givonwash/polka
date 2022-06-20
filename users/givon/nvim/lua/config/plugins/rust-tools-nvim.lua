return {
    ---@return nil
    setup = function()
        require('rust-tools').setup {
            server = require('config.plugins.nvim-lspconfig').client,
        }
    end,
}
