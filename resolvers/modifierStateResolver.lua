local playerBuffState = {
    ["Player"] = function(modifierState)
        local result = {}
        local varValue = modifierState.metadata.varPath.value
        if not modifierState.metadata.stackable then
            result.status = varValue == modifierState.metadata.actVal
        elseif modifierState.metadata.stackable then
            result.status = varValue >= modifierState.metadata.actVal
        end
        if modifierState.metadata.stackable then
            result.stacks = varValue
        end
        return result
    end,

    ["Relic"] = function(modifierState)
        local result = {}
        local relicFound = false
        for i = 1, 3 do
            local relicSlot = "ARCH_RELIC_LOADOUT_" ..
                var.VarPlayer.ARCH_RELIC_LOADOUT.value .. "_SLOT_" .. i .. "_ID"
            local relic = var.VarPlayer[relicSlot].value
            if relic == modifierState.metadata.actVal then
                relicFound = true
            end
        end
        result.status = relicFound
        return result
    end,

    ["NPC match"] = function(modifierState)
        local result = {}
        local varValue = var.VarPlayer.NPCTARGET.value
        if varValue == -1 then
            result.status = false
            return result
        end
        result.status = modifierState.metadata.varPath.value == varValue
        return result
    end,

    ["Living Death"] = function(modifierState)
        local result = {}
        result.status = modifierState.metadata.varPath.value:HasParam(config.Param.COMBATV2_ABILITY_ID)
        return result
    end,

    ["Client"] = function(modifierState, logicTick)
        local result = {}
        local varValue = modifierState.metadata.varPath.value
        result.status = varValue + modifierState.metadata.offset >= logicTick
        return result
    end,

    ["Stack to Static"] = function(modifierState)
        local result = {}
        local varValue = modifierState.metadata.varPath.value
        result.status = varValue >= modifierState.metadata.actVal
        return result
    end
}

return playerBuffState
