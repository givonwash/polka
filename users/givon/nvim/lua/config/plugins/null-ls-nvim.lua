return {
    ---@param opts table<string, (string|table<string, any>)[]>
    setup = function(opts)
        local null_ls = require 'null-ls'
        local configured_sources = {}

        for provider, sources in pairs(opts) do
            local builtins = null_ls.builtins[provider]

            for _, source in ipairs(sources) do
                if type(source) == 'string' then
                    table.insert(configured_sources, builtins[source])
                elseif type(source) == 'table' then
                    table.insert(configured_sources, builtins[source.source].with(source.config))
                else
                    local msg = 'Unexpected type %s received for null-ls source configuration'
                    error(string.format(msg, type(source)))
                end
            end
        end

        null_ls.setup {
            on_attach = require('config.plugins.nvim-lspconfig').client.on_attach,
            sources = configured_sources,
        }
    end,
}
