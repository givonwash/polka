---@alias NestedAnyTable table<string, table<string, any>>
--
---@class SourcesConfig
---@field code_actions? NestedAnyTable
---@field diagnostics? NestedAnyTable
---@field formatting? NestedAnyTable
---@field hover? NestedAnyTable
---@field completion? NestedAnyTable
--
return {
    ---@param sources SourcesConfig
    ---@return nil
    setup = function(sources)
        local null_ls = require("null-ls")
        ---@type any[]
        local configured_sources = {}

        for name, group in pairs(sources) do
            local builtins = null_ls.builtins[name]

            for source, config in pairs(group) do
                if config == nil then
                    table.insert(configured_sources, builtins[source])
                else
                    table.insert(configured_sources, builtins[source].with(config))
                end
            end
        end

        null_ls.setup {
            on_attach = require("plugins.nvim-lspconfig").client.on_attach,
            sources = configured_sources
        }
    end,
}
