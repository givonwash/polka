local fn = require 'utils.fn'
local lsp = vim.lsp
local M = {}

---@param config { disable_formatting?: boolean, extra_on_attach?: fun(client: table<string, any>, bufnr: integer): nil }
---@return table<string, any>
M.client = function(config)
    return {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
        handlers = {
            ['textDocument/hover'] = lsp.with(lsp.handlers.hover, {
                border = 'rounded',
            }),
            ['textDocument/signatureHelp'] = lsp.with(lsp.handlers.signature_help, {
                border = 'rounded',
                close_events = { 'CursorMoved', 'BufHidden', 'InsertCharPre' },
            }),
        },
        ---@param client table<string, any>
        ---@param bufnr integer
        ---@return nil
        on_attach = function(client, bufnr)
            local actions = require 'core.actions'
            require('core.keymaps').define {
                n = {
                    ['gd'] = { cmd = lsp.buf.definition, opts = { buffer = true } },
                    ['<C-k>'] = { cmd = lsp.buf.signature_help, opts = { buffer = true } },
                    ['ga'] = { cmd = lsp.buf.code_action, opts = { buffer = true } },
                    ['gr'] = { cmd = lsp.buf.rename, opts = { buffer = true } },
                    ['K'] = {
                        cmd = fn.defer(fn.find_ok, { { actions.goto_ft, lsp.buf.hover } }),
                        opts = { buffer = true },
                    },
                },
                i = {
                    ['<C-k>'] = { cmd = lsp.buf.signature_help, opts = { buffer = true } },
                },
            }

            if config.extra_on_attach ~= nil then
                config.extra_on_attach(client, bufnr)
            else
                local capabilities = client.server_capabilities

                if config.disable_formatting then
                    capabilities.documentFormattingProvider = false
                    capabilities.documentRangeFormattingProvider = false
                elseif capabilities.documentFormattingProvider then
                    require('core.autocmds').define_group(
                        string.format('FormatOnSaveClient%dBuf%d', client.id, bufnr),
                        {
                            {
                                event = 'BufWritePre',
                                opts = {
                                    buffer = bufnr,
                                    callback = fn.defer(lsp.buf.format),
                                },
                            },
                        }
                    )
                end
            end
        end,
    }
end

return M
