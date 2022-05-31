local M = {}

local lsp = vim.lsp

M.client = {
    capabilities = require("plugins.nvim-cmp")["lsp.capabilities"],
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
        require('core.keymaps').define({
            n = {
                ['gd'] = { cmd = lsp.buf.definition, opts = { buffer = true } },
                ['<C-k>'] = { cmd = lsp.buf.signature_help, opts = { buffer = true } },
                ['ga'] = { cmd = lsp.buf.code_action, opts = { buffer = true } },
                ['gr'] = { cmd = lsp.buf.rename, opts = { buffer = true } },
                ['K'] = { cmd = lsp.buf.hover, opts = { buffer = true } },
            },
            i = {
                ['<C-k>'] = { cmd = lsp.buf.signature_help, opts = { buffer = true } },
            }
        })

        if client.resolved_capabilities.document_formatting then
            local fn = require('utils.fn')

            require('core.autocmds').define_group(string.format('format_on_save_%d_%d', client.id, bufnr), {
                { event = 'BufWritePre', opts = { buffer = bufnr, callback = fn.defer(lsp.buf.formatting_sync, { nil, 1000 }) } }
            })
        end
    end,
}

M.server = {
    pyright = {
        settings = {
            python = { analysis = { { typeCheckingMode = 'strict' } } }
        }
    },
    rnix = {},
    sumneko_lua = {},
}

---@param servers { name: string, cmd: string[] }[]
---@return nil
M.setup = function(servers)
    for _, server in ipairs(servers) do
        local opts = vim.tbl_extend(
            "keep",
            { cmd = server.cmd },
            M.server[server.name],
            M.client
        )
        require("lspconfig")[server.name].setup(opts)
    end
end

return M
