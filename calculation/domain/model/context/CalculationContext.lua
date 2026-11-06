---@class CalculationContext # All fields are private to prevent unintentional mutations
---@field private equipmentContext EquipmentContext A current snapshot of the user's worn equipment
---@field private skillsContext    SkillsContext    A current snapshot of the user's stats
---@field private buffContext      BuffContext      A current snapshot of the user's active buffs and buff stacks
---@field private perkContext      PerkContext      A current snapshot of the user's equipped perks and perk ranks
---@field private familiarContext  FamiliarContext  A current snapshot of the user's summoned familiar
---@field private targetContext    TargetContext    A current snapshot of the user's active target
---@field private prayerContext    PrayerContext    A current snapshot of the user's active prayers
---@field private hitCapMode       HitCapMode       The user's selection of applied hitcap

local CalculationContext = {}

---@param equipmentContext EquipmentContext
---@param skillsContext SkillsContext
---@param buffContext BuffContext
---@param perkContext PerkContext
---@param familiarContext FamiliarContext
---@param targetContext TargetContext
---@param prayerContext PrayerContext
---@param hitCapMode HitCapMode
function CalculationContext:build(equipmentContext, skillsContext, buffContext,
                                  perkContext, familiarContext, targetContext,
                                  prayerContext, hitCapMode)
    local o = {
        equipmentContext = equipmentContext,
        skillsContext = skillsContext,
        buffContext = buffContext,
        perkContext = perkContext,
        familiarContext = familiarContext,
        targetContext = targetContext,
        prayerContext = prayerContext,
        hitCapMode = hitCapMode
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

-- Getters:
function CalculationContext:getEquipmentContext()
    return self.equipmentContext
end

function CalculationContext:getSkillsContext()
    return self.skillsContext
end

function CalculationContext:getBuffContext()
    return self.buffContext
end

function CalculationContext:getPerkContext()
    return self.perkContext
end

function CalculationContext:getFamiliarContext()
    return self.familiarContext
end

function CalculationContext:getTargetContext()
    return self.targetContext
end

function CalculationContext:getPrayerContext()
    return self.prayerContext
end

function CalculationContext:getHitCapMode()
    return self.hitCapMode
end

return CalculationContext
