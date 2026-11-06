---@class EquipmentSlot
---@field id integer
---@field title string Name of equipment slot item
---@field slot EquipmentSlots Equipment slot of the equipped item
---@field effects [EquipmentEffects]
local EquipmentSlot = {}

---@param id? integer
---@param title? string
---@param slot? EquipmentSlots
---@param effects [EquipmentEffects]
function EquipmentSlot:build(id, title, slot, effects)
    local o = {
        id = id,
        title = title,
        slot = slot,
        effects = effects
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function EquipmentSlot:emptySlot()
    local slot = EquipmentSlot:build(nil, nil, nil, {})
    return slot
end

return EquipmentSlot
