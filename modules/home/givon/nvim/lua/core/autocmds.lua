return {
    ---@param group string|{ name: string, opts?: { clear: boolean } }
    ---@param cmds { event: string|string[], opts: table<string, any> }[]
    ---@return nil
    define_group = function(group, cmds)
        local api = vim.api
        local group_id

        if type(group) == 'table' then
            group_id = api.nvim_create_augroup(group.name, group.opts)
        else
            group_id = api.nvim_create_augroup(group, {})
        end

        for _, cmd in ipairs(cmds) do
            local opts = vim.tbl_extend('force', cmd.opts, { group = group_id })
            api.nvim_create_autocmd(cmd.event, opts)
        end
    end,
}
