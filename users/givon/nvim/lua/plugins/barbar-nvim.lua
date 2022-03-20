return {
    ---@return nil
    setup = function()
        vim.g.bufferline = {
            animation = false,
            auto_hide = true,
            tabpages = true,
            closable = true,
            clickable = true,
            icons = true,
            icon_custom_colors = false,
            icon_separator_active = '▎',
            icon_separator_inactive = '▎',
            icon_close_tab = 'X',
            icon_close_tab_modified = '●',
            icon_pinned = '車',
            insert_at_end = true,
            maximum_padding = 1,
            maximum_length = 30,
            semantic_letters = true,
            letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',
            no_name_title = nil,
        }

        require("core.keymaps").define {
            n = {
                -- navigate buffers
                ['gb'] = '<cmd>BufferNext<cr>',
                ['gB'] = '<cmd>BufferPrevious<cr>',

                -- move buffers
                ['gmp'] = '<cmd>BufferMovePrevious<cr>',
                ['gmn'] = '<cmd>BufferMoveNext<cr>',

                -- goto buffers
                ['g1'] = '<cmd>BufferGoto 1<cr>',
                ['g2'] = '<cmd>BufferGoto 2<cr>',
                ['g3'] = '<cmd>BufferGoto 3<cr>',
                ['g4'] = '<cmd>BufferGoto 4<cr>',
                ['g5'] = '<cmd>BufferGoto 5<cr>',
                ['g6'] = '<cmd>BufferGoto 6<cr>',
                ['g7'] = '<cmd>BufferGoto 7<cr>',
                ['g8'] = '<cmd>BufferGoto 8<cr>',
                ['gl'] = '<cmd>BufferLast<cr>',
                ['gp'] = '<cmd>BufferPick<cr>',

                -- sort buffers
                ['god'] = '<cmd>BufferOrderByDirectory<cr>',
                ['gol'] = '<cmd>BufferOrderByLanguage<cr>',

                -- close buffers
                ['g.'] = '<cmd>BufferClose<cr>',
            }
        }
    end
}
