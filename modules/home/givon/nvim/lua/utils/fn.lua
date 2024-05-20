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

---@generic T
---@param fns (fun(): T)[]
---@return T?
M.find_ok = function(fns)
    for _, fn in ipairs(fns) do
        local ok, result = pcall(fn)

        if ok then
            return result
        end
    end
end

return M
