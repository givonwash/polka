return {
    {
        'norcalli/nvim-colorizer.lua',
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
