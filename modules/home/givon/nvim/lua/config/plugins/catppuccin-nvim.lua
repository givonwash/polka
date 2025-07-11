return {
    {
        'catppuccin/catppuccin-nvim',
        priority = 1000,
        opts = {
            integrations = { lsp_trouble = true },
        },
        config = function(_, opts)
            vim.g.catppuccin_flavour = 'mocha'

            require('catppuccin').setup(opts)

            vim.cmd [[colorscheme catppuccin]]
        end,
    },
}
