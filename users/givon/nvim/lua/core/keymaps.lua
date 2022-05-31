---@alias AnyFn fun(): any
---@alias Command { cmd: string|AnyFn, opts?: table<string, any> }
---@alias Definitions table<string, string|AnyFn|Command>
return {
    ---@param definitions table<string, Definitions>
    ---@return nil
    define = function(definitions)
        local defaults = { noremap = true, silent = true }

        for mode, bindings in pairs(definitions) do
            for keys, cmd in pairs(bindings) do
                local cmd_type = type(cmd)
                if cmd_type == 'string' or cmd_type == 'function' then
                    vim.keymap.set(mode, keys, cmd, defaults)
                elseif cmd_type == 'table' then
                    local opts = vim.tbl_extend('force', defaults, cmd.opts or {})
                    vim.keymap.set(mode, keys, cmd.cmd, opts)
                else
                    vim.notify(string.format("Unsupported type %s provided to define", cmd_type))
                end
            end
        end
    end,
}

