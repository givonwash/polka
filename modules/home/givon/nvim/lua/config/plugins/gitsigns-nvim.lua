return {
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            on_attach = function()
                require('core.keymaps').define {
                    n = {
                        ['<leader>gb'] = {
                            cmd = require('gitsigns').blame_line,
                            opts = { buffer = true },
                        },
                        ['<leader>gd'] = {
                            cmd = require('gitsigns').diffthis,
                            opts = { buffer = true },
                        },
                        ['<leader>gj'] = {
                            cmd = require('gitsigns').next_hunk,
                            opts = { buffer = true },
                        },
                        ['<leader>gk'] = {
                            cmd = require('gitsigns').prev_hunk,
                            opts = { buffer = true },
                        },
                        ['<leader>gp'] = {
                            cmd = require('gitsigns').preview_hunk,
                            opts = { buffer = true },
                        },
                        ['<leader>gr'] = {
                            cmd = require('gitsigns').reset_hunk,
                            opts = { buffer = true },
                        },
                    },
                    o = {
                        ['ih'] = {
                            cmd = require('gitsigns').select_hunk,
                            opts = { buffer = true },
                        },
                    },
                    v = {
                        ['<leader>gr'] = {
                            cmd = require('gitsigns').reset_hunk,
                            opts = { buffer = true },
                        },
                        ['ih'] = {
                            cmd = require('gitsigns').select_hunk,
                            opts = { buffer = true },
                        },
                    },
                }
            end,
        },
    },
}
