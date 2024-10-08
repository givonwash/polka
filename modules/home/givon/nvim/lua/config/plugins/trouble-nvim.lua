return {
    ---@return nil
    setup = function()
        local fn = require 'utils.fn'
        local keymaps = require 'core.keymaps'

        local trouble = require 'trouble'

        trouble.setup()

        keymaps.define {
            n = {
                ['<leader>tt'] = '<cmd>Trouble diagnostics<cr>',
                ['<leader>tq'] = '<cmd>Trouble quickfix<cr>',
                ['<leader>tl'] = '<cmd>Trouble loclist<cr>',
            },
        }

        require('core.autocmds').define_group('TroubleConfig', {
            {
                event = 'FileType',
                opts = {
                    callback = fn.defer(keymaps.define, {
                        {
                            n = {
                                ['<leader>tj'] = fn.defer(
                                    trouble.next,
                                    { { skip_groups = true, jump = true } }
                                ),
                                ['<leader>tk'] = fn.defer(
                                    trouble.previous,
                                    { { skip_groups = true, jump = true } }
                                ),
                            },
                        },
                    }),
                    pattern = { 'Trouble' },
                },
            },
        })
    end,
}
