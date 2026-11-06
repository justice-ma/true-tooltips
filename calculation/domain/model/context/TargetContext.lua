---@class TargetContext
---@field private id integer
---@field private currentHp integer
---@field private size integer
---@field private name string
---@field private tags TargetTags[]
---@field private initialAssignmentCount? integer
---@field private currentAssignmentCount? integer
local TargetContext = {}
TargetContext.maxHp = 100

---@param id integer
---@param currentHp integer
---@param size integer
---@param name string
---@param tags TargetTags[]
---@param initialAssignmentCount? integer
---@param currentAssignmentCount? integer
function TargetContext:build(id, currentHp, size, name, tags,
                             initialAssignmentCount, currentAssignmentCount)
    local o = {
        id = id,
        currentHp = currentHp,
        size = size,
        name = name,
        tags = tags,
        initialAssignmentCount = initialAssignmentCount,
        currentAssignmentCount = currentAssignmentCount
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function TargetContext:getId()
    if self.id ~= nil then
        return self.id
    end
end

function TargetContext:getCurrentHp()
    if self.currentHp ~= nil then
        return self.currentHp
    end
end

---@param hp integer
function TargetContext:setCurrentHp(hp)
    self.currentHp = hp
end

function TargetContext:getMaxHp()
    if self.maxHp ~= nil then
        return self.maxHp
    end
end

function TargetContext:getName()
    if self.name ~= nil then
        return self.name
    end
end

function TargetContext:getTags()
    if self.tags ~= nil then
        return self.tags
    end
end

function TargetContext:getInitialAssignmentCount()
    if self.initialAssignmentCount ~= nil then
        return self.initialAssignmentCount
    end
end

function TargetContext:getCurrentAssignmentCount()
    if self.currentAssignmentCount ~= nil then
        return self.currentAssignmentCount
    end
end

return TargetContext
