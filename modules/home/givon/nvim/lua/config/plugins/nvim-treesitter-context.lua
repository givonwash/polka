return {
    ---@return nil
    setup = function()
        require('treesitter-context').setup { mode = 'topline' }
    end,
}
