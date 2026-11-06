local EquipmentSlot = require "calculation/domain/model/context/EquipmentSlot"

---@class EquipmentContext # All fields marked private to avoid unintentional manipulation. All fields are currently worn <slot>
---@field private head EquipmentSlot
---@field private body EquipmentSlot
---@field private legs EquipmentSlot
---@field private boots EquipmentSlot
---@field private gloves EquipmentSlot
---@field private cape EquipmentSlot
---@field private pocket EquipmentSlot
---@field private neck EquipmentSlot
---@field private ring EquipmentSlot
---@field private ammo EquipmentSlot Active ammo, not necessarily quiver slot
---@field private quiver EquipmentSlot Equipped quiver, not necessarily quiver slot
---@field private mainhand EquipmentSlot
---@field private offhand EquipmentSlot
---@field private combatStyle CombatStyles Current mainhand's combat style
local EquipmentContext = {}

---@param head? EquipmentSlot
---@param body? EquipmentSlot
---@param legs? EquipmentSlot
---@param boots? EquipmentSlot
---@param gloves? EquipmentSlot
---@param cape? EquipmentSlot
---@param pocket? EquipmentSlot
---@param neck? EquipmentSlot
---@param ring? EquipmentSlot
---@param ammo? EquipmentSlot
---@param quiver? EquipmentSlot
---@param mainhand? EquipmentSlot
---@param offhand? EquipmentSlot
---@param combatStyle CombatStyles
function EquipmentContext:build(head, body, legs, boots,
                                gloves, cape, pocket, neck,
                                ring, ammo, quiver, mainhand,
                                offhand, combatStyle)
    local o = {
        head = head,
        body = body,
        legs = legs,
        boots = boots,
        gloves = gloves,
        cape = cape,
        pocket = pocket,
        neck = neck,
        ring = ring,
        ammo = ammo,
        quiver = quiver,
        mainhand = mainhand,
        offhand = offhand,
        combatStyle = combatStyle
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function EquipmentContext:fillMissingWithEmpty()
    if self.head == nil then self:setHead(EquipmentSlot:emptySlot()) end
    if self.body == nil then self:setBody(EquipmentSlot:emptySlot()) end
    if self.legs == nil then self:setLegs(EquipmentSlot:emptySlot()) end
    if self.boots == nil then self:setBoots(EquipmentSlot:emptySlot()) end
    if self.gloves == nil then self:setGloves(EquipmentSlot:emptySlot()) end
    if self.cape == nil then self:setCape(EquipmentSlot:emptySlot()) end
    if self.pocket == nil then self:setPocket(EquipmentSlot:emptySlot()) end
    if self.neck == nil then self:setNeck(EquipmentSlot:emptySlot()) end
    if self.ring == nil then self:setRing(EquipmentSlot:emptySlot()) end
    if self.ammo == nil then self:setAmmo(EquipmentSlot:emptySlot()) end
    if self.quiver == nil then self:setQuiver(EquipmentSlot:emptySlot()) end
    if self.mainhand == nil then self:setMainhand(EquipmentSlot:emptySlot()) end
    if self.offhand == nil then self:setOffhand(EquipmentSlot:emptySlot()) end
end

-- Getters and Setters:
function EquipmentContext:getHead()
    return self.head
end

---@param equipmentSlot EquipmentSlot
function EquipmentContext:setHead(equipmentSlot)
    if equipmentSlot ~= nil then
        self.head = equipmentSlot
    end
end

function EquipmentContext:getBody()
    return self.body
end

---@param equipmentSlot EquipmentSlot
function EquipmentContext:setBody(equipmentSlot)
    if equipmentSlot ~= nil then
        self.body = equipmentSlot
    end
end

function EquipmentContext:getLegs()
    return self.legs
end

---@param equipmentSlot EquipmentSlot
function EquipmentContext:setLegs(equipmentSlot)
    if equipmentSlot ~= nil then
        self.legs = equipmentSlot
    end
end

function EquipmentContext:getBoots()
    return self.boots
end

---@param equipmentSlot EquipmentSlot
function EquipmentContext:setBoots(equipmentSlot)
    if equipmentSlot ~= nil then
        self.boots = equipmentSlot
    end
end

function EquipmentContext:getGloves()
    return self.gloves
end

---@param equipmentSlot EquipmentSlot
function EquipmentContext:setGloves(equipmentSlot)
    if equipmentSlot ~= nil then
        self.gloves = equipmentSlot
    end
end

function EquipmentContext:getCape()
    return self.cape
end

---@param equipmentSlot EquipmentSlot
function EquipmentContext:setCape(equipmentSlot)
    if equipmentSlot ~= nil then
        self.cape = equipmentSlot
    end
end

function EquipmentContext:getPocket()
    return self.pocket
end

---@param equipmentSlot EquipmentSlot
function EquipmentContext:setPocket(equipmentSlot)
    if equipmentSlot ~= nil then
        self.pocket = equipmentSlot
    end
end

function EquipmentContext:getNeck()
    return self.neck
end

---@param equipmentSlot EquipmentSlot
function EquipmentContext:setNeck(equipmentSlot)
    if equipmentSlot ~= nil then
        self.neck = equipmentSlot
    end
end

function EquipmentContext:getRing()
    return self.ring
end

---@param equipmentSlot EquipmentSlot
function EquipmentContext:setRing(equipmentSlot)
    if equipmentSlot ~= nil then
        self.ring = equipmentSlot
    end
end

function EquipmentContext:getAmmo()
    return self.ammo
end

---@param equipmentSlot EquipmentSlot
function EquipmentContext:setAmmo(equipmentSlot)
    if equipmentSlot ~= nil then
        self.ammo = equipmentSlot
    end
end

function EquipmentContext:getQuiver()
    return self.quiver
end

---@param equipmentSlot EquipmentSlot
function EquipmentContext:setQuiver(equipmentSlot)
    if equipmentSlot ~= nil then
        self.quiver = equipmentSlot
    end
end

function EquipmentContext:getMainhand()
    return self.mainhand
end

---@param equipmentSlot EquipmentSlot
function EquipmentContext:setMainhand(equipmentSlot)
    if equipmentSlot ~= nil then
        self.mainhand = equipmentSlot
    end
end

function EquipmentContext:getOffhand()
    return self.offhand
end

---@param equipmentSlot EquipmentSlot
function EquipmentContext:setOffhand(equipmentSlot)
    if equipmentSlot ~= nil then
        self.offhand = equipmentSlot
    end
end

function EquipmentContext:getCombatStyle()
    return self.combatStyle
end

---@param combatStyle CombatStyles
function EquipmentContext:setCombatStyle(combatStyle)
    if combatStyle ~= nil then
        self.combatStyle = combatStyle
    end
end

return EquipmentContext
