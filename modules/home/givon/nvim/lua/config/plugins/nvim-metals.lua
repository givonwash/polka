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
                                metals.bare_config(),
                                { settings = { showImplicitArguments = true } }
                            )
                        )
                    end,
                },
            },
        })
    end,
}
