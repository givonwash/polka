return {
    ---@return nil
    setup = function()
        local notify = require 'notify'

        notify.setup {
            stages = 'slide',
        }

        vim.notify = notify
    end,
}
