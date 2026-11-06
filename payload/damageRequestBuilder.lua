local modifierPayload      = require "state/modifierPayload"
local damageRequest        = require "payload/damageRequest"
local equipment            = require "state/equipmentContainer"
local statsContainer       = require "state/statsContainer"
local spellEnums           = require "lookups/spellEnumLookup"

local damageRequestBuilder = {
    build = function()
        damageRequest.equipment = nil
        damageRequest.buffs = {}

        -- Skills population
        damageRequest.skills = statsContainer

        -- EquipmentIds population
        if next(equipment.equipment) ~= nil then
            damageRequest.equipment = {}
            for index, value in pairs(equipment.equipment) do
                if value.slot ~= nil then
                    damageRequest.equipment[value.slot] = value.object.id
                end
            end
        end

        -- BuffSet population
        damageRequest.buffs.enabledBuffs = {}
        for index, value in pairs(modifierPayload.buffs) do
            table.insert(damageRequest.buffs.enabledBuffs, index)
        end
        table.sort(damageRequest.buffs.enabledBuffs) -- stable order between ticks

        -- BuffStacks population
        damageRequest.buffs.buffStacks = modifierPayload.buffStacks

        -- targetMaxHp population - coeff based
        damageRequest.targetMaxHp = 100

        -- targetCurrentHp population - coeff based
        if var.VarPlayer.NPCTARGET.value == -1 then
            damageRequest.targetCurrentHp = 100
        else
            damageRequest.targetCurrentHp = (var.VarClient.COMBATV2_TARGET_SIDE_PANEL_HEALTH.value / 20 // 1) * 20
        end

        -- potions population: empty list for v1, sandboxing of overloads not currently supported
        damageRequest.potions = {}

        -- Spells population
        damageRequest.spell = spellEnums[var.VarPlayer.LASTCASTSPELL.value]

        -- Set<Prayer> population
        damageRequest.selectedPrayers = {}
        for index, value in pairs(modifierPayload.prayers) do
            table.insert(damageRequest.selectedPrayers, index)
        end
        table.sort(damageRequest.selectedPrayers) -- stable order between ticks

        -- Familiars population
        damageRequest.selectedFamiliar = nil
        if var.VarPlayer.FOLLOWER_OBJ.value:GetParamValue(config.Param.FOLLOWER_NPC).id == 26877 then
            damageRequest.selectedFamiliar = "KALGERIONDEMON"
        elseif var.VarPlayer.FOLLOWER_OBJ.value:GetParamValue(config.Param.FOLLOWER_NPC).id == 26879 then
            damageRequest.selectedFamiliar = "RIPPERDEMON"
        end

        -- PerkSelection population
        damageRequest.perks = {}
        if next(modifierPayload.selectedPerks) ~= nil then
            damageRequest.perks.selectedPerks = modifierPayload.selectedPerks
        end
        damageRequest.perks.itemLevel20   = modifierPayload.itemLevel20.active
        damageRequest.perks.genocidalRank = modifierPayload.genocidal.modifier

        -- HitCapMode population: TODO
        damageRequest.hitCapMode          = "CAP_30000"

        -- Base ability damage population
        local mainhand                    = var.VarPlayer.COMBATV2_MAINHAND_STRENGTH_NORMALISED.value
        local offhand                     = math.floor(var.VarPlayer.COMBATV2_OFFHAND_STRENGTH_NORMALISED.value * 0.5)
        damageRequest.baseAbilityDamage   = mainhand + offhand
    end,
    buildAbilityId = function(abilityName)
        local qualifies       = false
        local tooltipMetadata = require "metadata/tooltipMetadata"
        -- AbilityId population:
        if abilityName ~= nil and tooltipMetadata[abilityName] then
            local metadata = tooltipMetadata[abilityName]
            if metadata.alternateAbilityEnum ~= nil and metadata.alternateQualifier ~= nil then
                qualifies = metadata.alternateQualifier.qualify(equipment)
                if qualifies then
                    return metadata.alternateAbilityEnum
                else
                    return metadata.abilityEnum
                end
            else
                return metadata.abilityEnum
            end
        else
            return nil
        end
    end
}

return damageRequestBuilder
