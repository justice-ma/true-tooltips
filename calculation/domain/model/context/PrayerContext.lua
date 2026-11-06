---@class PrayerContext
---@field private activePrayers Prayers[]
---@field private prayerStrengthBonus integer
local PrayerContext = {}

---@param activePrayers Prayers[]
function PrayerContext:build(activePrayers)
    local o = { activePrayers = activePrayers }
    setmetatable(o, self)
    self.__index = self
    return o
end

---@param prayer Prayers
function PrayerContext:has(prayer)
    for k, v in ipairs(self.activePrayers) do
        if v == prayer then
            return true
        end
    end
    return false
end

function PrayerContext:getActivePrayers()
    if self.activePrayers ~= nil then
        return self.activePrayers
    end
end

function PrayerContext:getPrayerStrengthBonus()
    if self.prayerStrengthBonus ~= nil then
        return self.prayerStrengthBonus
    end
end

---@param prayerStrengthBonus integer
function PrayerContext:setPrayerStrengthBonus(prayerStrengthBonus)
    self.prayerStrengthBonus = prayerStrengthBonus
end

return PrayerContext
