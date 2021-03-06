---@class Set
---@field _hashed table<string|integer, boolean>
local Set = {}

---@param elements (string|integer)[]
---@return Set
function Set:new(elements)
    local hashed = {}
    for _, element in ipairs(elements) do
        hashed[element] = true
    end

    self.__index = self
    return setmetatable({ _hashed = hashed }, self)
end

---@param element string|integer
---@return boolean
function Set:contains(element)
    return self._hashed[element] == true
end

return Set
