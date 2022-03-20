return {
    ---@return nil
    setup = function()
        require("gitsigns").setup {
            signs = {
                add = { text = '|' },
                change = { text = '|' },
                delete = { text = '|' },
                topdelete = { text = '⤒' },
                changedelete = { text = '↹' },
            },
            on_attach = function()
                require('core.keymaps').define {
                    n = {
                        ['<leader>gb'] = { cmd = '<cmd>lua require("gitsigns").blame_line()<cr>', is_buf_local = true },
                        ['<leader>gj'] = { cmd = '<cmd>lua require("gitsigns").next_hunk()<cr>', is_buf_local = true },
                        ['<leader>gk'] = { cmd = '<cmd>lua require("gitsigns").prev_hunk()<cr>', is_buf_local = true },
                        ['<leader>gp'] = { cmd = '<cmd>lua require("gitsigns").preview_hunk()<cr>', is_buf_local = true },
                        ['<leader>gr'] = { cmd = '<cmd>lua require("gitsigns").reset_hunk()<cr>', is_buf_local = true },
                    },
                    o = {
                        ['ih'] = { cmd = ':<C-u>lua require("gitsigns").select_hunk()<cr>', is_buf_local = true },
                    },
                    v = {
                        ['<leader>gr'] = { cmd = '<cmd>lua require("gitsigns").reset_hunk()<cr>', is_buf_local = true },
                        ['ih'] = { cmd = ':<C-u>lua require("gitsigns").select_hunk()<cr>', is_buf_local = true },
                    }
                }

            end,
        }
    end
}
