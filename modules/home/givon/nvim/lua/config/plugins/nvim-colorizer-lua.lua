return {
    {
        'norcalli/nvim-colorizer.lua',
        name = 'nvim-colorizer.lua',
        event = 'VeryLazy',
        opts = {
            filetypes = {
                'html',
                'javascript',
                'typescript',
                css = { css = true },
            },
        },
    },
}
