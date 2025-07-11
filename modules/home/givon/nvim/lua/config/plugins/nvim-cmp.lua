local icons = {
    Text = '',
    Method = '',
    Function = '',
    Constructor = '',
    Field = '',
    Variable = '',
    Class = '',
    Interface = '',
    Module = '',
    Property = '',
    Unit = '',
    Value = '',
    Enum = '',
    Keyword = '',
    Snippet = '',
    Color = '',
    File = '',
    Reference = '',
    Folder = '',
    EnumMember = '',
    Constant = '',
    Struct = '"',
    Event = '',
    Operator = '',
    TypeParameter = '',
}

return {
    {
        'hrsh7th/nvim-cmp',
        name = 'nvim-cmp',
        opts = {
            formatting = {
                format = function(_, item)
                    item.kind = string.format('%s %s', icons[item.kind], item.kind)
                    return item
                end,
            },
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
        },
        config = function(_, opts)
            vim.opt.completeopt = 'menu,menuone,noselect'

            local cmp = require 'cmp'

            cmp.setup(vim.tbl_extend('keep', opts, {
                mapping = {
                    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
                    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
                    ['<C-e>'] = cmp.mapping {
                        i = cmp.mapping.abort(),
                        c = cmp.mapping.close(),
                    },
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = false,
                    },
                    ---@param fallback fun(): nil
                    ['<TAB>'] = function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif
                            vim.bo.buftype ~= 'prompt'
                            and require('utils.buf').cursor_follows_word()
                        then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end,
                    ---@param fallback fun(): nil
                    ['<S-TAB>'] = function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end,
                },
                sources = cmp.config.sources {
                    { name = 'nvim_lsp' },
                    { name = 'buffer' },
                    { name = 'luasnip' },
                    { name = 'path' },
                    { name = 'emoji' },
                    { name = 'render_markdown' },
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
            }))
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources { { name = 'path' }, { name = 'cmdline' } },
            })
        end,
    },
}
