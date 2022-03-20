return {
    ---@return nil
    setup = function()
        require("catppuccin").setup {
            integrations = {
                barbar = true,
                bufferline = false,
                dashboard = false,
                lsp_trouble = true,
                indent_blankline = { enabled = false },
                symbols_outline = false
            }
        }

        vim.cmd [[colorscheme catppuccin]]
    end
}
