return {
    ---@return nil
    setup = function()
        require('nvim-treesitter.configs').setup {
            highlight = {
                enable = true,
            },
        }
    end,
}
