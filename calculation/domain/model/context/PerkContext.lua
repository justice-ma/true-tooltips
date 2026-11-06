---@class PerkContext
---@field private perkMap table<Perks, integer>
---@field private perkItemLevel20 table<Perks, boolean>

local PerkContext = {}

---@param perkMap table<Perks, integer>
---@param perkItemLevel20 table<Perks, boolean>
function PerkContext:build(perkMap, perkItemLevel20)
    local o = {
        perkMap = perkMap,
        perkItemLevel20 = perkItemLevel20
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

---@param perk Perks
function PerkContext:has(perk)
    for k, v in pairs(self.perkMap) do
        if k == perk then
            return true
        end
    end
    return false
end

---@param perk Perks
function PerkContext:rank(perk)
    for k, v in pairs(self.perkMap) do
        if k == perk then
            return v
        end
    end
    return 0
end

---@param perk Perks
function PerkContext:empowered(perk)
    for k, v in pairs(self.perkItemLevel20) do
        if k == perk then
            return v
        end
    end
    return false
end

function PerkContext:getPerkMap()
    if self.perkMap ~= nil then
        return self.perkMap
    end
end

function PerkContext:getPerkItemLevel20()
    if self.perkItemLevel20 ~= nil then
        return self.perkItemLevel20
    end
end

return PerkContext
