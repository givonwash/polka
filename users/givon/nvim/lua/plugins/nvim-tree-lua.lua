return {
    ---@return nil
    setup = function()
        vim.g.nvim_tree_respect_buf_cwd = 1

        require("nvim-tree").setup {
            update_cwd = true,
            update_focused_file = {
                enabled = true,
                update_cwd = true,
            }
        }
        require("core.keymaps").define {
            n = {
                ["<leader>e"] = "<cmd>NvimTreeToggle<cr>"
            }
        }
    end
}
