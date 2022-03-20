return {
    ---@return nil
    setup = function()
        require("rust-tools").setup {
            server = require("plugins.nvim-lspconfig").client
        }
    end
}
