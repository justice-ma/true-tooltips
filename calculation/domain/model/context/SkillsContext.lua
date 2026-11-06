local EquipmentContext = require "calculation/domain/model/context/EquipmentContext"

---@class SkillsContext # For v1, includes only base strength stats to derive base crit chance and LP state.
---@field private baseStrength integer
---@field private baseRanged integer
---@field private baseMagic integer
---@field private baseNecromancy integer
---@field private currentHp integer
---@field private maxHp integer

local SkillsContext = {}

---@param strength integer
---@param ranged integer
---@param magic integer
---@param necromancy integer
---@param currentHp integer
---@param maxHp integer
function SkillsContext:build(strength, ranged, magic, necromancy,
                             currentHp, maxHp)
    local o = {
        baseStrength = strength,
        baseRanged = ranged,
        baseMagic = magic,
        baseNecromancy = necromancy,
        currentHp = currentHp,
        maxHp = maxHp
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

---@param equipmentContext EquipmentContext
function SkillsContext:getRelevantStrengthLevel(equipmentContext)
    ---@type CombatStyles
    local combatStyle = EquipmentContext.getCombatStyle(equipmentContext)
    if combatStyle == "RANGED" then
        return self.baseRanged
    elseif combatStyle == "MELEE" then
        return self.baseStrength
    elseif combatStyle == "NECROMANCY" then
        return self.baseNecromancy
    elseif combatStyle == "MAGIC" then
        return self.baseMagic
    else
        return 0
    end
end

function SkillsContext:correctBoundaries()
    if self:getBaseStrength() > 120 then self:setBaseStrength(120) end
    if self:getBaseRanged() > 120 then self:setBaseRanged(120) end
    if self:getBaseNecromancy() > 120 then self:setBaseNecromancy(120) end
    if self:getBaseMagic() > 120 then self:setBaseMagic(120) end
    if self:getBaseStrength() < 1 then self:setBaseStrength(1) end
    if self:getBaseRanged() < 1 then self:setBaseRanged(1) end
    if self:getBaseNecromancy() < 1 then self:setBaseNecromancy(1) end
    if self:getBaseMagic() < 1 then self:setBaseMagic(1) end
    if self:getCurrentHp() > 32000 then self:setCurrentHp(32000) end
    if self:getCurrentHp() < 1 then self:setCurrentHp(1) end
    if self:getMaxHp() > 32000 then self:setMaxHp(32000) end
    if self:getMaxHp() < 1 then self:setMaxHp(1) end
end

-- Getters and setters:
function SkillsContext:getBaseStrength()
    return self.baseStrength
end

---@param level integer
function SkillsContext:setBaseStrength(level)
    if level ~= nil then
        self.baseStrength = level
    end
end

function SkillsContext:getBaseRanged()
    return self.baseRanged
end

---@param level integer
function SkillsContext:setBaseRanged(level)
    if level ~= nil then
        self.baseRanged = level
    end
end

function SkillsContext:getBaseNecromancy()
    return self.baseNecromancy
end

---@param level integer
function SkillsContext:setBaseNecromancy(level)
    if level ~= nil then
        self.baseNecromancy = level
    end
end

function SkillsContext:getBaseMagic()
    return self.baseMagic
end

---@param level integer
function SkillsContext:setBaseMagic(level)
    if level ~= nil then
        self.baseMagic = level
    end
end

function SkillsContext:getCurrentHp()
    return self.currentHp
end

---@param hp integer
function SkillsContext:setCurrentHp(hp)
    if hp ~= nil then
        self.currentHp = hp
    end
end

function SkillsContext:getMaxHp()
    return self.maxHp
end

---@param hp integer
function SkillsContext:setMaxHp(hp)
    if hp ~= nil then
        self.maxHp = hp
    end
end

return SkillsContext
