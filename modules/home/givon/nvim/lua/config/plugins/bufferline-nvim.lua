return {
    ---@return nil
    setup = function()
        require('bufferline').setup()

        require('core.keymaps').define {
            n = {
                ['gb'] = '<cmd>BufferLineCycleNext<cr>',
                ['gB'] = '<cmd>BufferLineCyclePrev<cr>',
                ['gmb'] = '<cmd>BufferLineMoveNext<cr>',
                ['gmB'] = '<cmd>BufferLineMovePrev<cr>',
                ['gp'] = '<cmd>BufferLinePick<cr>',
                ['gsd'] = '<cmd>BufferLineSortByDirectory<cr>',
                ['gse'] = '<cmd>BufferLineSortByExtension<cr>',
            },
        }
    end,
}
