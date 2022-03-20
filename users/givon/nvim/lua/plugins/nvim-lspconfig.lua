---@class Server
---@field name string
---@field cmd string[]

local M = {}

M.client = {
    capabilities = require("plugins.nvim-cmp")["lsp.capabilities"],
    handlers = {
        ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = 'rounded',
        }),
        ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
            border = 'rounded',
            close_events = { 'CursorMoved', 'BufHidden', 'InsertCharPre' },
        }),
    },
    -- @param client table<string, any>
    -- @return nil
    on_attach = function(client)
        require('core.keymaps').define({
            n = {
                ['gd'] = { cmd = '<cmd>lua vim.lsp.buf.definition()<cr>', is_buf_local = true },
                ['<C-k>'] = { cmd = '<cmd>lua vim.lsp.buf.signature_help()<cr>', is_buf_local = true },
                ['ga'] = { cmd = '<cmd>lua vim.lsp.buf.code_action()<cr>', is_buf_local = true },
                ['gr'] = { cmd = '<cmd>lua vim.lsp.buf.rename()<cr>', is_buf_local = true },
                ['K'] = { cmd = '<cmd>lua vim.lsp.buf.hover()<cr>', is_buf_local = true },
            },
            i = {
                ['<C-k>'] = { cmd = '<cmd>lua vim.lsp.buf.signature_help()<cr>', is_buf_local = true },
            }
        })

        if client.resolved_capabilities.document_formatting then
            vim.cmd [[au BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)]]
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

---@param servers Server[]
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
