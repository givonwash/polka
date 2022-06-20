local M = {}

local lsp = vim.lsp

local IGNORED_FORMATTING_SERVERS = require('lib.collections').Set:new { 'sumneko_lua' }

M.client = {
    capabilities = require('config.plugins.nvim-cmp')['lsp.capabilities'],
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
        require('core.keymaps').define {
            n = {
                ['gd'] = { cmd = lsp.buf.definition, opts = { buffer = true } },
                ['<C-k>'] = { cmd = lsp.buf.signature_help, opts = { buffer = true } },
                ['ga'] = { cmd = lsp.buf.code_action, opts = { buffer = true } },
                ['gr'] = { cmd = lsp.buf.rename, opts = { buffer = true } },
                ['K'] = { cmd = lsp.buf.hover, opts = { buffer = true } },
            },
            i = {
                ['<C-k>'] = { cmd = lsp.buf.signature_help, opts = { buffer = true } },
            },
        }

        local capabilities = client.resolved_capabilities

        if IGNORED_FORMATTING_SERVERS:contains(client.name) then
            capabilities.document_formatting = false
            capabilities.document_range_formatting = false
        elseif capabilities.document_formatting then
            local fn = require 'utils.fn'

            require('core.autocmds').define_group(string.format('FormatOnSave', client.id, bufnr), {
                {
                    event = 'BufWritePre',
                    opts = {
                        buffer = bufnr,
                        callback = fn.defer(lsp.buf.formatting_sync, { nil, 1000 }),
                    },
                },
            })
        end
    end,
}

---@param servers { name: string, opts?: table<string, any> }[]
---@return nil
M.setup = function(servers)
    for _, server in ipairs(servers) do
        local opts = vim.tbl_extend('keep', server.opts or {}, M.client)
        require('lspconfig')[server.name].setup(opts)
    end
end

return M
