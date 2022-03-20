return {
    ---@return nil
    setup = function()
        require('core.autocmds').define_group({
            [[au FileType help,man wincmd L]],
            [[au BufWritePre * mark ` | %s:\v\s+$::ge | normal! ``]],
            [[au TextYankPost * silent! lua vim.highlight.on_yank() ]],
        }, 'vimrc')

        require('core.keymaps').define({
            i = {
                -- leave insert mode
                ['jj'] = '<esc>'
            },
            n = {
                -- pane navigation & manipulation
                ['<M-h>'] = '<cmd>wincmd h<cr>',
                ['<M-j>'] = '<cmd>wincmd j<cr>',
                ['<M-k>'] = '<cmd>wincmd k<cr>',
                ['<M-l>'] = '<cmd>wincmd l<cr>',
                ['<S-M-h>'] = '<cmd>wincmd H<cr>',
                ['<S-M-j>'] = '<cmd>wincmd J<cr>',
                ['<S-M-k>'] = '<cmd>wincmd K<cr>',
                ['<S-M-l>'] = '<cmd>wincmd L<cr>',
                ['<leader>o'] = '<cmd>only<cr>',
                ['<leader>c'] = '<cmd>close<cr>',

                -- buffer navigation
                ['j'] = 'gj',
                ['k'] = 'gk',
                ['zl'] = 'zL',
                ['zh'] = 'zH',

                -- quickfix list navigation
                ['<C-n>'] = '<cmd>cnext<cr>',
                ['<C-p>'] = '<cmd>cprev<cr>',

                -- location list navigation
                ['<M-n>'] = '<cmd>lnext<cr>',
                ['<M-p>'] = '<cmd>lprev<cr>',

                -- create new line above/below
                ['oo'] = 'm`o<esc>``',
                ['OO'] = 'm`O<esc>``',

                -- copy/paste system clipboard
                ['<leader>y'] = { cmd = '"+y', opts = { silent = false }},
                ['<leader>p'] = { cmd = '"+p', opts = { silent = false }},

                -- better searching
                ['?'] = { cmd = '?\\v', opts = { silent = false }},
                ['/'] = { cmd = '/\\v', opts = { silent = false }},

                -- fast substitution
                ['<leader><leader>'] = { cmd = ':%s:\\v::g<left><left><left>', opts = { silent = false }},
                ['<leader>;'] = { cmd = ':s:\\v::g<left><left><left>', opts = { silent = false }},
                ["<leader>'"] = { cmd = ':.,$s:\\v::g<left><left><left>', opts = { silent = false }},
                ['<leader>k'] = { cmd = ':%s:\\v<<C-r><C-w>>::g<left><left>', opts = { silent = false }},

                -- fast increment/decrement
                ['<leader>a'] = { cmd = ':s:\\v\\d+:\\=submatch(0) + 1:ge<cr>', opts = { silent = false }},
                ['<leader>x'] = { cmd = ':s:\\v\\d+:\\=submatch(0) - 1:ge<cr>', opts = { silent = false }},

                -- fast :g commands
                ['<leader>g'] = { cmd = ':%g:\\v', opts = { silent = false }},

                -- toggle spell checking
                ['<leader>s'] = '<cmd>setlocal spell!<cr>',

                -- turn off highlights for current search
                ['<leader>h'] = '<cmd>nohlsearch<cr>',

                -- toggle relative number
                ['<leader>r'] = '<cmd>set relativenumber!<cr>',
            },
            t = {
                -- leave terminal mode
                ['jj'] = '<C-\\><C-N>',

                -- pane navigation & manipulation
                ['<M-h>'] = '<C-\\><C-N><cmd>wincmd h<cr>',
                ['<M-j>'] = '<C-\\><C-N>cmd>wincmd j<cr>',
                ['<M-k>'] = '<C-\\><C-N>cmd>wincmd k<cr>',
                ['<M-l>'] = '<C-\\><C-N>cmd>wincmd l<cr>',
                ['<S-M-h>'] = '<C-\\><C-N>cmd>wincmd H<cr>',
                ['<S-M-j>'] = '<C-\\><C-N>cmd>wincmd J<cr>',
                ['<S-M-k>'] = '<C-\\><C-N>cmd>wincmd K<cr>',
                ['<S-M-l>'] = '<C-\\><C-N>cmd>wincmd L<cr>',
            },
            v = {
                -- copy/paste system clipboard
                ['<leader>y'] = { cmd = '"+y', opts = { silent = false }},
                ['<leader>p'] = { cmd = '"+p', opts = { silent = false }},
            }
        })

        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.opt.colorcolumn = { '+1' }
        vim.opt.cursorline = true
        vim.opt.signcolumn = 'yes'
        vim.opt.wrap = false
        vim.opt.expandtab = true
        vim.opt.smartindent = true
        vim.opt.autoindent = true
        vim.opt.shiftwidth = 4
        vim.opt.tabstop = 4
        vim.opt.softtabstop = 4
        vim.opt.undofile = true
        vim.opt.timeoutlen = 300
        vim.opt.splitright = true
        vim.opt.splitbelow = true
        vim.opt.hidden = true
        vim.opt.ignorecase = true
        vim.opt.smartcase = true
        vim.opt.smarttab = true
        vim.opt.incsearch = true
        vim.opt.scrolloff = 2
        vim.opt.history = 500
        vim.opt.lazyredraw = true
        vim.opt.showmode = false
        vim.opt.termguicolors = true
        vim.opt.conceallevel = 2

        vim.fn.sign_define {
            { name = 'DiagnosticSignError', text = '', numhl = 'LspDiagnosticsError' },
            { name = 'DiagnosticSignWarn', text = '', numhl = 'LspDiagnosticsWarning' },
            { name = 'DiagnosticSignInfo', text = '', numhl = 'LspDiagnosticsInformation' },
            { name = 'DiagnosticSignHint', text = '', numhl = 'LspDiagnosticsHint' },
        }
    end
}
