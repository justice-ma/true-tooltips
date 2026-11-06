local equipmentSlot = require "lookups/equipmentSlotLookup"

local inventoryStateResolver = {
    resolve = function(slotIdMin, slotIdMax, inventoryType, inventoryContainer, inventoryFieldName)
        local previousTickInventory = inventoryContainer[inventoryFieldName]
        inventoryContainer[inventoryFieldName] = {}
        local inventorySlot = Inventory.Find(config.Inv[inventoryType])
        for i = slotIdMin, slotIdMax do
            local slot = inventorySlot:GetSlot(i)
            if slot.count > 0 then
                local slotId = nil
                if inventoryType == "WORN" then
                    slotId = equipmentSlot[i]
                else
                    slotId = i
                end
                inventoryContainer[inventoryFieldName][slot.obj.configName] = { object = slot.obj, slot = slotId }
            end
        end

        if inventoryType == "WORN" and var.VarPlayer.QUIVER_ACTIVE_AMMO.value.id ~= -1 then
            local ammo = var.VarPlayer.QUIVER_ACTIVE_AMMO.value
            inventoryContainer[inventoryFieldName][ammo.configName] = { object = ammo, slot = equipmentSlot[20] }
        end


        if previousTickInventory ~= nil then
            for index, value in pairs(previousTickInventory) do
                if not inventoryContainer[inventoryFieldName][index] then
                    print(inventoryType, " - removed:", value.object.configName, value.slot)
                end
            end
            for index, value in pairs(inventoryContainer[inventoryFieldName]) do
                if not previousTickInventory[index] then
                    print(inventoryType, " - equipped:", value.object.name, value.slot)
                end
            end
        else
            for index, value in pairs(inventoryContainer[inventoryFieldName]) do
                print(inventoryType, " - equipped:", value.object.name, value.slot)
            end
        end
    end
}

return inventoryStateResolver
