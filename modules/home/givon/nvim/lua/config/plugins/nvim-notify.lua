return {
    {
        'rcarriga/nvim-notify',
        name = 'nvim-notify',
        config = function()
            local notify = require 'notify'

            notify.setup {
                stages = 'slide',
            }

            vim.notify = notify
        end,
    },
}
