return {
    ---@return nil
    setup = function()
        local fn = require 'utils.fn'

        require('core.keymaps').define {
            n = {
                ['<leader>fb'] = fn.defer(require('telescope.builtin').buffers),
                ['<leader>fc'] = fn.defer(require('telescope.builtin').commands),
                ['<leader>fd'] = fn.defer(require('telescope.builtin').diagnostics),
                ['<leader>ff'] = fn.defer(require('telescope.builtin').find_files),
                ['<leader>fg'] = fn.defer(require('telescope.builtin').git_files),
                ['<leader>fh'] = fn.defer(require('telescope.builtin').help_tags),
                ['<leader>fk'] = fn.defer(require('telescope.builtin').grep_string),
                ['<leader>fm'] = fn.defer(require('telescope.builtin').man_pages),
                ['<leader>fr'] = fn.defer(require('telescope.builtin').live_grep),
                ['<leader>ft'] = fn.defer(require('telescope.builtin').builtin),
                ['<leader>fs'] = fn.defer(require('telescope.builtin').lsp_references),
                ['<leader>fw'] = fn.defer(
                    require('telescope.builtin').lsp_dynamic_workspace_symbols
                ),
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
