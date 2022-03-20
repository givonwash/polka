---@class Definitions
---@field i? table<string, string|Command>
---@field n? table<string, string|Command>
---@field o? table<string, string|Command>
---@field t? table<string, string|Command>
---@field v? table<string, string|Command>

---@class Command
---@field cmd string
---@field is_buf_local? boolean
---@field opts? table<string, string>
return {
    ---@param definitions Definitions
    ---@return nil
    define = function(definitions)
        local api = vim.api
        local defaults = { noremap = true, silent = true }

        for mode, bindings in pairs(definitions) do
            for keys, cmd in pairs(bindings) do
		        local cmd_type = type(cmd)
                if cmd_type == 'string' then
                    api.nvim_set_keymap(mode, keys, cmd, defaults)
                elseif cmd_type == 'table' then
                    local opts = vim.tbl_extend('force', defaults, cmd.opts or {})
                    if cmd.is_buf_local then
                        api.nvim_buf_set_keymap(0, mode, keys, cmd.cmd, opts)
                    else
                        api.nvim_set_keymap(mode, keys, cmd.cmd, opts)
                    end
                else
                    vim.notify(string.format("Unsupported type %s provided to define", cmd_type))
                end
            end
        end
    end,
}

