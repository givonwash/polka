return {
    {
        'nvim-tree/nvim-tree.lua',
        opts = {
            renderer = {
                group_empty = true,
            },
            respect_buf_cwd = true,
            update_cwd = true,
            update_focused_file = {
                enable = true,
                update_cwd = true,
            },
            view = {
                float = {
                    enable = true,
                    open_win_config = function()
                        local cmdheight = vim.opt.cmdheight:get()
                        local screen_width = vim.opt.columns:get()
                        local screen_height = vim.opt.lines:get()
                        local effective_screen_height = screen_height - cmdheight

                        local window_width = math.floor(screen_width * 0.8)
                        local window_height = math.floor(effective_screen_height * 0.8)
                        local column = (screen_width - window_width) / 2
                        local row = ((screen_height - window_height) / 2) - cmdheight

                        return {
                            border = 'rounded',
                            relative = 'editor',
                            col = column,
                            row = row,
                            height = window_height,
                            width = window_width,
                        }
                    end,
                },
            },
        },
        config = function(_, opts)
            require('nvim-tree').setup(opts)
            require('core.keymaps').define {
                n = {
                    ['<leader>e'] = '<cmd>NvimTreeToggle<cr>',
                },
            }
        end,
    },
}
