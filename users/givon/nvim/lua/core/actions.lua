local fn = require 'utils.fn'

return {
    goto_ft = fn.defer(
        ---@param gotos table<string, fun(string): string>
        function(gotos)
            local cursorword = vim.fn.expand '<cword>'
            vim.api.nvim_command(gotos[vim.bo.filetype](cursorword))
        end,
        {
            {
                help = function(cursorword)
                    return 'tag ' .. cursorword
                end,
                man = function(cursorword)
                    return 'Man ' .. cursorword
                end,
                vim = function(cursorword)
                    return 'tag ' .. cursorword
                end,
            },
        }
    ),
}
