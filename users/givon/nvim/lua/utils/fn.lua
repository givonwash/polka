local M = {}

---@generic T
---@param fn fun(...): T
---@param args? any
---@return fun(): T
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
