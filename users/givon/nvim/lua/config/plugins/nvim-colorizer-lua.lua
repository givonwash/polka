return {
    ---@return nil
    setup = function()
        require('colorizer').setup {
            filetypes = {
                'html',
                'javascript',
                'typescript',
                css = { css = true },
            },
        }
    end,
}
