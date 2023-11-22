return {
    ---@return nil
    setup = function()
        require('core.keymaps').define {
            n = {
                ['<leader>fb'] = require('telescope.builtin').buffers,
                ['<leader>fc'] = require('telescope.builtin').commands,
                ['<leader>fd'] = require('telescope.builtin').diagnostics,
                ['<leader>ff'] = require('telescope.builtin').find_files,
                ['<leader>fg'] = require('telescope.builtin').git_files,
                ['<leader>fh'] = require('telescope.builtin').help_tags,
                ['<leader>fk'] = require('telescope.builtin').grep_string,
                ['<leader>fm'] = require('telescope.builtin').man_pages,
                ['<leader>fr'] = require('telescope.builtin').live_grep,
                ['<leader>ft'] = require('telescope.builtin').builtin,
                ['<leader>fs'] = require('telescope.builtin').lsp_references,
                ['<leader>fw'] = require('telescope.builtin').lsp_dynamic_workspace_symbols,
            },
        }

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
                        ['<TAB>'] = actions.move_selection_previous,
                        ['<S-TAB>'] = actions.move_selection_next,
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
            },
        }
    end,
}
