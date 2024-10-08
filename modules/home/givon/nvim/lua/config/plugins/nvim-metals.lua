return {
    setup = function()
        local metals = require 'metals'
        require('core.autocmds').define_group('nvim-metals', {
            {
                event = 'FileType',
                opts = {
                    pattern = { 'scala', 'sbt' },
                    callback = function()
                        metals.initialize_or_attach(
                            vim.tbl_extend(
                                'keep',
                                require('config.plugins.nvim-lspconfig').client {},
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
}
