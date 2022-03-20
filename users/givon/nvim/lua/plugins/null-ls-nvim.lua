return {
    ---@return nil
    setup = function()
        require("null-ls").setup {
            on_attach = require("plugins.nvim-lspconfig").client.on_attach
        }
    end
}
