return {
    ---@return nil
    setup = function()
        require('colorizer').setup {
            'html',
            'javascript',
            'typescript',
            css = { css = true },
        }
    end,
}
