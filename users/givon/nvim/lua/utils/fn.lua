local M = {}

---@param fn fun(...): any
---@param args? any
---@return nil
M.defer = function(fn, args)
    return function()
        if args == nil then
            fn()
        elseif type(args) == 'table' then
            fn(unpack(args))
        else
            fn(args)
        end
    end
end

return M
