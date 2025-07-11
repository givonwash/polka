return {
    {
        'MeanderingProgrammer/render-markdown.nvim',
        ft = { 'markdown' },
        config = function()
            local render_markdown = require 'render-markdown'
            render_markdown.setup()
            require('core.keymaps').define {
                n = {
                    ['<leader>mm'] = render_markdown.toggle(),
                    ['<leader>me'] = render_markdown.expand(),
                    ['<leader>mc'] = render_markdown.contract(),
                },
            }
        end,
    },
}
