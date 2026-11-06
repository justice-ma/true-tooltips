---@class BuffContext
---@field private buffSet BuffId[]
---@field private buffStackMap table<BuffId, integer>
local BuffContext = {}

---@param buffSet BuffId[]
---@param buffStackMap table<BuffId, integer>
function BuffContext:build(buffSet, buffStackMap)
    local o = { buffSet = buffSet, buffStackMap = buffStackMap }
    setmetatable(o, self)
    self.__index = self
    return o
end

---@param buff BuffId
function BuffContext:has(buff)
    for k, v in ipairs(self.buffSet) do
        if v == buff then
            return true
        end
    end

    for k in pairs(self.buffStackMap) do
        if k == buff then
            return true
        end
    end

    return false
end

---@param buff BuffId
function BuffContext:stacks(buff)
    if not self:has(buff) then return 0 end
    for k, v in pairs(self.buffStackMap) do
        if k == buff then
            return v
        end
    end
    return 0
end

-- Getters:
function BuffContext:getBuffSet()
    if self.buffSet ~= nil then
        return self.buffSet
    end
end

function BuffContext:getBuffStackMap()
    if self.buffStackMap ~= nil then
        return self.buffStackMap
    end
end

return BuffContext
