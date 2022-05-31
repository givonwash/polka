local M = {}

---@class Set
---@field _hashed table<string|integer, boolean>
M.set = {}

---@vararg string|integer
---@return Set
function M.set:new(...)
    local hashed = {}
    for _, hashable in ipairs { ... } do
        hashed[hashable] = true
    end

    self.__index = self
    return setmetatable({ _hashed = hashed }, self)
end

---@param e string|integer
---@return boolean
function M.set:contains(e)
    return self._hashed[e] == true
end

return M
