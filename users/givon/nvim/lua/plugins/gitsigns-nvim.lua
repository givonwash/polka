return {
    ---@return nil
    setup = function()
        local fn = require 'utils.fn'

        require('gitsigns').setup {
            on_attach = function()
                require('core.keymaps').define {
                    n = {
                        ['<leader>gb'] = {
                            cmd = fn.defer(require('gitsigns').blame_line),
                            opts = { buffer = true },
                        },
                        ['<leader>gd'] = {
                            cmd = fn.defer(require('gitsigns').diffthis),
                            opts = { buffer = true },
                        },
                        ['<leader>gj'] = {
                            cmd = fn.defer(require('gitsigns').next_hunk),
                            opts = { buffer = true },
                        },
                        ['<leader>gk'] = {
                            cmd = fn.defer(require('gitsigns').prev_hunk),
                            opts = { buffer = true },
                        },
                        ['<leader>gp'] = {
                            cmd = fn.defer(require('gitsigns').preview_hunk),
                            opts = { buffer = true },
                        },
                        ['<leader>gr'] = {
                            cmd = fn.defer(require('gitsigns').reset_hunk),
                            opts = { buffer = true },
                        },
                    },
                    o = {
                        ['ih'] = {
                            cmd = fn.defer(require('gitsigns').select_hunk),
                            opts = { buffer = true },
                        },
                    },
                    v = {
                        ['<leader>gr'] = {
                            cmd = fn.defer(require('gitsigns').reset_hunk),
                            opts = { buffer = true },
                        },
                        ['ih'] = {
                            cmd = fn.defer(require('gitsigns').select_hunk),
                            opts = { buffer = true },
                        },
                    },
                }
            end,
        }
    end,
}
