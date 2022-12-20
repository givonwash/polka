return {
    ---@return nil
    setup = function()
        local truezen = require 'true-zen'

        truezen.setup {
            integrations = { lualine = true },
        }

        require('core.keymaps').define {
            n = {
                ['<leader>zf'] = truezen.focus,
                ['<leader>zm'] = truezen.minimalist,
                ['<leader>za'] = truezen.ataraxis,
            },
            v = {
                ['<leader>zn'] = function()
                    local start = vim.fn.line 'v'
                    local stop = vim.fn.line '.'
                    truezen.narrow(start, stop)
                end,
            },
        }
    end,
}
