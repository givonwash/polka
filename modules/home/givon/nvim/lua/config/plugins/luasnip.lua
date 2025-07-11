return {
    {
        'L3MON4D3/LuaSnip',
        config = function()
            local luasnip = require 'luasnip'

            require('core.keymaps').define {
                i = {
                    ['<C-n>'] = function()
                        if luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end,
                    ['<C-p>'] = function()
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end,
                    ['<C-l>'] = function()
                        if luasnip.choice_active() then
                            luasnip.change_choice(1)
                        end
                    end,
                },
                s = {
                    ['<C-n>'] = function()
                        if luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end,
                    ['<C-p>'] = function()
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end,
                    ['<C-l>'] = function()
                        if luasnip.choice_active() then
                            luasnip.change_choice(1)
                        end
                    end,
                },
            }

            require('luasnip.loaders.from_vscode').lazy_load()
        end,
    },
}
