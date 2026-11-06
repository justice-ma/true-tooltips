---@class FamiliarContext
---@field private familiar Familiars
local FamiliarContext = {}

---@param familiar Familiars
function FamiliarContext:build(familiar)
    local o = { familiar = familiar }
    setmetatable(o, self)
    self.__index = self
    return o
end

function FamiliarContext:getFamiliar()
    if self.familiar ~= nil then
        return self.familiar
    end
end

return FamiliarContext
