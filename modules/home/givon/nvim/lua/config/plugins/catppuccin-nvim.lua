return {
    ---@return nil
    setup = function()
        vim.g.catppuccin_flavour = 'mocha'

        require('catppuccin').setup {
            integrations = { lsp_trouble = true },
        }

        vim.cmd [[colorscheme catppuccin]]
    end,
}
