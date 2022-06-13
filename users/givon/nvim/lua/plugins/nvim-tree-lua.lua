return {
    ---@return nil
    setup = function()
        require('nvim-tree').setup {
            respect_buf_cwd = true,
            update_cwd = true,
            update_focused_file = {
                enable = true,
                update_cwd = true,
            },
        }
        require('core.keymaps').define {
            n = {
                ['<leader>e'] = '<cmd>NvimTreeToggle<cr>',
            },
        }
    end,
}
