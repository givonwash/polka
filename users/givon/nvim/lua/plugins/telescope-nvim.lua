return {
    ---@return nil
    setup = function()
        require("core.keymaps").define({
            n = {
                ["<leader>fb"] = [[<cmd>lua require("telescope.builtin").buffers()<cr>]],
                ["<leader>ff"] = [[<cmd>lua require("telescope.builtin").find_files()<cr>]],
                ["<leader>fg"] = [[<cmd>lua require("telescope.builtin").git_files()<cr>]],
                ["<leader>fh"] = [[<cmd>lua require("telescope.builtin").help_tags()<cr>]],
                ["<leader>fk"] = [[<cmd>lua require("telescope.builtin").grep_string()<cr>]],
                ["<leader>fm"] = [[<cmd>lua require("telescope.builtin").man_pages()<cr>]],
                ["<leader>fr"] = [[<cmd>lua require("telescope.builtin").live_grep()<cr>]],
                ["<leader>ft"] = [[<cmd>lua require("telescope.builtin").builtin()<cr>]],
                ["<leader>fs"] = [[<cmd>lua require("telescope.builtin").lsp_references()<cr>]]
            }
        })

        local actions = require 'telescope.actions'

        require('telescope').setup {
            defaults = {
                prompt_prefix = ':: 🐵 :: ',
                selection_caret = '→ ',
                path_display = { 'smart' },
                mappings = {
                    i = {
                        ['<C-c>'] = false,
                        ['<C-n>'] = false,
                        ['<C-p>'] = false,
                        ['<Esc>'] = actions.close,
                        ['<C-s>'] = actions.toggle_selection,
                        ['<C-j>'] = actions.move_selection_next,
                        ['<C-k>'] = actions.move_selection_previous,
                    },
                },
            },
            pickers = {
                file_browser = {
                    hidden = true,
                },
                man_pages = {
                    sections = { 'ALL' },
                },
            }
        }
    end
}
