return {
    {
        'scalameta/nvim-metals',
        name = 'nvim-metals',
        config = function()
            require('core.autocmds').define_group('nvim-metals', {
                {
                    event = 'FileType',
                    opts = {
                        pattern = { 'java', 'scala', 'sbt' },
                        callback = function()
                            local metals = require 'metals'
                            require('core.keymaps').define {
                                n = {
                                    ['<leader>fl'] = require('telescope').extensions.metals.commands,
                                },
                            }
                            vim.opt_global.shortmess:remove 'F'
                            metals.initialize_or_attach(
                                vim.tbl_extend(
                                    'keep',
                                    require('lib.plugins.nvim-lspconfig').client {},
                                    {
                                        init_options = { statusBarProvider = 'on ' },
                                        settings = {
                                            excludedPackages = {
                                                'akka.actor.typed.javadsl',
                                                'com.github.swagger.akka.javadsl',
                                            },
                                            showImplicitArguments = true,
                                            showImplicitConversionsAndClasses = true,
                                            showInferredType = true,
                                            superMethodLensesEnabled = true,
                                            useGlobalExecutable = true,
                                        },
                                    },
                                    metals.bare_config()
                                )
                            )
                        end,
                    },
                },
            })
        end,
    },
}
