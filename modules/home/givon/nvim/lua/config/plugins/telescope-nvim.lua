return {
    {
        'nvim-telescope/telescope.nvim',
        opts = function()
            return {
                defaults = {
                    prompt_prefix = ':: 🐵 :: ',
                    selection_caret = '→ ',
                    path_display = { 'smart' },
                    mappings = {
                        i = {
                            ['<C-c>'] = false,
                            ['<C-n>'] = false,
                            ['<C-p>'] = false,
                            ['<Esc>'] = function(bufnr)
                                require('telescope.actions').close(bufnr)
                            end,
                            ['<C-s>'] = function(bufnr)
                                require('telescope.actions').toggle_selection(bufnr)
                            end,
                            ['<C-j>'] = function(bufnr)
                                require('telescope.actions').move_selection_next(bufnr)
                            end,
                            ['<C-k>'] = function(bufnr)
                                require('telescope.actions').move_selection_previous(bufnr)
                            end,
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
        keys = {
            {
                '<leader>fb',
                function()
                    require('telescope.builtin').buffers()
                end,
            },
            {
                '<leader>fc',
                function()
                    require('telescope.builtin').commands()
                end,
            },
            {
                '<leader>fd',
                function()
                    require('telescope.builtin').diagnostics()
                end,
            },
            {
                '<leader>ff',
                function()
                    require('telescope.builtin').find_files()
                end,
            },
            {
                '<leader>fg',
                function()
                    require('telescope.builtin').git_files()
                end,
            },
            {
                '<leader>fh',
                function()
                    require('telescope.builtin').help_tags()
                end,
            },
            {
                '<leader>fk',
                function()
                    require('telescope.builtin').grep_string()
                end,
            },
            {
                '<leader>fm',
                function()
                    require('telescope.builtin').man_pages()
                end,
            },
            {
                '<leader>fr',
                function()
                    require('telescope.builtin').live_grep()
                end,
            },
            {
                '<leader>ft',
                function()
                    require('telescope.builtin').builtin()
                end,
            },
            {
                '<leader>fs',
                function()
                    require('telescope.builtin').lsp_references()
                end,
            },
            {
                '<leader>fw',
                function()
                    require('telescope.builtin').lsp_dynamic_workspace_symbols()
                end,
            },
        },
    },
}
