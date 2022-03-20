return {
    ---@param autocmds string[] #autocmds to include in the augroup
    ---@param name string #name of the augroup
    ---@return nil
    define_group = function(autocmds, name)
        local cmd = vim.cmd
        cmd('augroup ' .. name)
        cmd 'autocmd!'
        for _, au in pairs(autocmds) do
            cmd(au)
        end
        cmd 'augroup end'
    end
}
