local fn = require 'utils.fn'

return {
    setup = function()
        local client = require('config.plugins.nvim-lspconfig').client {
            extra_on_attach = function(client, bufnr)
                require('core.autocmds').define_group(
                    string.format('FormatOnSaveClient%dBuf%d', client.id, bufnr),
                    {
                        {
                            event = 'BufWritePre',
                            opts = {
                                buffer = bufnr,
                                callback = fn.defer(function()
                                    require('typescript-tools.api').sort_imports(true)
                                    vim.lsp.buf.format()
                                end),
                            },
                        },
                    }
                )
            end,
        }

        require('typescript-tools').setup(vim.tbl_extend('keep', client, {
            settings = {
                tsserver_file_preferences = {
                    includeInlayParameterNameHints = 'all',
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
            },
        }))
    end,
}
