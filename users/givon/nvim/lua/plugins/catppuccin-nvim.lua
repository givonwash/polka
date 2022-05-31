return {
    ---@return nil
    setup = function()
        require("catppuccin").setup {
            integrations = { lsp_trouble = true }
        }

        vim.cmd [[colorscheme catppuccin]]
    end
}
