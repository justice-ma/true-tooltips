local tooltipMetadata = {}

local function inventionRankSprite(result)
    return "INVENTION_ICON_PERK_RANK_" .. result.rank
end

tooltipMetadata["Greater Ricochet"] = {
    levelRequirement = "67",
    adrenalineDelta = "9%",
    cooldownSeconds = "10.2s",
    targetting = "Multi",
    targettingSprite = id.Sprite.ABILITY_ICON_TOOLTIP_TARGET_MULTIPLE,
    abilityEnum = "GREATERRICOCHET",
    alternateAbilityEnum = nil,
    alternateQualifier = nil,
    modifiers = {
        caroming = function(modifierState)
            local result = {}
            result.active = false
            result.sprite = id.Sprite.INVENTION_ICON_PERKS_COMBAT_CAROMING
            result.label = "Caroming"
            result.rank = nil
            if modifierState.caroming.status then
                result.active = true
                result.rank = tostring(modifierState.caroming.stacks)
                result.rankSprite = inventionRankSprite(result)
            end
            return result
        end
    },
    combatStyle = "RANGED"
}
tooltipMetadata["Deadshot"] = {
    levelRequirement = "21",
    adrenalineDelta = "-60%",
    cooldownSeconds = "30s",
    targetting = "Single",
    targettingSprite = id.Sprite.ABILITY_ICON_TOOLTIP_TARGET_SINGLE,
    abilityEnum = "DEADSHOT",
    alternateAbilityEnum = "DEADSHOTIGNEOUS",
    alternateQualifier = {
        qualify = function(equipmentContainer)
            return equipmentContainer.equipment["EGWD_FUL_BOSS_FLAWLESS_CAPE"] ~= nil or
                equipmentContainer.equipment["EGWD_FUL_BOSS_RANGED_CAPE"] ~= nil
        end
    },
    modifiers = {
        ultimatums = function(modifierState, equipmentContainer)
            local result = {}
            result.active = false
            result.rank = nil
            result.sprite = id.Sprite.INVENTION_ICON_PERKS_COMBAT_ULTIMATUMS
            result.label = "Ultimatums"
            result.rankSprite = nil

            if modifierState.ultimatums.status == true then
                result.active = true
                result.rank = tostring(modifierState.ultimatums.stacks)
                result.rankSprite = inventionRankSprite(result)
            end
            return result
        end,
        zukCape = function(modifierState, equipmentContainer)
            local result = {}
            result.active = false
            result.sprite = id.Sprite.RS3_ICON_WORN_EQUIPMENT_1
            result.label = "Igneous Kal-Cape"
            result.rank = nil

            if equipmentContainer.equipment["EGWD_FUL_BOSS_FLAWLESS_CAPE"] ~= nil or
                equipmentContainer.equipment["EGWD_FUL_BOSS_RANGED_CAPE"] ~= nil then
                result.active = true
                if equipmentContainer.equipment["EGWD_FUL_BOSS_FLAWLESS_CAPE"] ~= nil then
                    result.label = equipmentContainer.equipment["EGWD_FUL_BOSS_FLAWLESS_CAPE"].object.name
                elseif equipmentContainer.equipment["EGWD_FUL_BOSS_RANGED_CAPE"] ~= nil then
                    result.label = equipmentContainer.equipment["EGWD_FUL_BOSS_RANGED_CAPE"].object.name
                end
            end
            return result
        end
    },
    combatStyle = "RANGED"
}
tooltipMetadata["Ranged"] = {
    levelRequirement = "1",
    adrenalineDelta = "9%",
    cooldownSeconds = "1.8s",
    targetting = "Single",
    targettingSprite = id.Sprite.ABILITY_ICON_TOOLTIP_TARGET_SINGLE,
    abilityEnum = "RANGEDAUTO",
    alternateAbilityEnum = nil,
    alternateQualifier = nil,
    modifiers = nil,
    combatStyle = "RANGED"
}
tooltipMetadata["Piercing Shot"] = {
    levelRequirement = "13",
    adrenalineDelta = "9%",
    cooldownSeconds = "3s",
    targetting = "Single",
    targettingSprite = id.Sprite.ABILITY_ICON_TOOLTIP_TARGET_SINGLE,
    abilityEnum = "PIERCINGSHOT",
    alternateAbilityEnum = nil,
    alternateQualifier = nil,
    modifiers = {
        fleetingBoots = function(modifierState, equipmentContainer)
            local result = {}
            result.active = false
            result.rank = nil
            result.sprite = id.Sprite.RS3_ICON_WORN_EQUIPMENT_9
            result.label = "Fleeting Boots"

            if equipmentContainer.equipment["DINO_SLAYER_RANGED_BOOTS_UPGRADED_USED"] or
                equipmentContainer.equipment["DINO_SLAYER_RANGED_BOOTS_USED"] then
                result.active = true
            end
            return result
        end
    },
    combatStyle = "RANGED"
}
tooltipMetadata["Binding Shot"] = {
    levelRequirement = "31",
    adrenalineDelta = "9%",
    cooldownSeconds = "15s",
    targetting = "Single",
    targettingSprite = id.Sprite.ABILITY_ICON_TOOLTIP_TARGET_SINGLE,
    abilityEnum = "BINDINGSHOT",
    alternateAbilityEnum = nil,
    alternateQualifier = nil,
    modifiers = {
        flanking = function(modifierState, equipmentContainer)
            local result = {}
            result.active = false
            result.rank = modifierState.flanking.stacks
            result.sprite = id.Sprite.INVENTION_ICON_PERKS_WEAPONS_FLANKING
            result.label = "Flanking"
            result.rankSprite = nil

            if modifierState.flanking.status then
                result.active = true
                result.rank = tostring(modifierState.flanking.stacks)
                result.rankSprite = inventionRankSprite(result)
            end

            return result
        end,
        binds = function(modifierState, equipmentContainer)
            local result = {}
            result.active = true
            result.rank = nil
            result.sprite = id.Sprite.AIF_MAGIC_STANDARD_ICONS_60
            result.label = "9.6s"
            result.rankSprite = nil

            if modifierState.flanking.status then
                result.active = false
            end

            return result
        end,
        stuns = function(modifierState, equipmentContainer)
            local result = {}
            result.active = true
            result.rank = nil
            result.sprite = id.Sprite.COMBAT_ICON_BUFF_10
            result.label = "1.2s"
            result.rankSprite = nil

            if modifierState.flanking.status then
                result.active = false
            end

            return result
        end
    },
    combatStyle = "RANGED"
}
tooltipMetadata["Snap Shot"] = {
    levelRequirement = "2",
    adrenalineDelta = "-25%",
    cooldownSeconds = "1.8s",
    targetting = "Single",
    targettingSprite = id.Sprite.ABILITY_ICON_TOOLTIP_TARGET_SINGLE,
    abilityEnum = "SNAPSHOT",
    alternateAbilityEnum = nil,
    alternateQualifier = nil,
    modifiers = nil,
    combatStyle = "RANGED"
}
tooltipMetadata["Snipe"] = {
    levelRequirement = "7",
    adrenalineDelta = "-",
    cooldownSeconds = "1m",
    targetting = "Single",
    targettingSprite = id.Sprite.ABILITY_ICON_TOOLTIP_TARGET_SINGLE,
    abilityEnum = "SNIPE",
    alternateAbilityEnum = nil,
    alternateQualifier = nil,
    modifiers = {
        fleetingBoots = function(modifierState, equipmentContainer)
            local result = {}
            result.active = false
            result.rank = nil
            result.sprite = id.Sprite.RS3_ICON_WORN_EQUIPMENT_9
            result.label = "Fleeting Boots"

            if equipmentContainer.equipment["DINO_SLAYER_RANGED_BOOTS_UPGRADED_USED"] or
                equipmentContainer.equipment["DINO_SLAYER_RANGED_BOOTS_USED"] then
                result.active = true
            end
            return result
        end,
        nightmareGauntlets = function(modifierState, equipmentContainer)
            local result = {}
            result.active = false
            result.rank = nil
            result.sprite = id.Sprite.RS3_ICON_WORN_EQUIPMENT_8
            result.label = "Nightmares"

            if equipmentContainer.equipment["ENHANCED_FOTG2_GLOVES_RANGE_USED"] or
                equipmentContainer.equipment["FOTG2_GLOVES_RANGE_USED"] then
                result.active = true
            end
            return result
        end,
    },
    combatStyle = "RANGED"
}
tooltipMetadata["Bombardment"] = {
    levelRequirement = "36",
    adrenalineDelta = "-25%",
    cooldownSeconds = "1.8s",
    targetting = "Area",
    targettingSprite = id.Sprite.ABILITY_ICON_TOOLTIP_TARGET_AOE,
    abilityEnum = "BOMBARDMENT",
    alternateAbilityEnum = nil,
    alternateQualifier = nil,
    modifiers = nil,
    combatStyle = "RANGED"
}
tooltipMetadata["Rapid Fire"] = {
    levelRequirement = "62",
    adrenalineDelta = "-25%",
    cooldownSeconds = "20.4s",
    targetting = "Single",
    targettingSprite = id.Sprite.ABILITY_ICON_TOOLTIP_TARGET_SINGLE,
    abilityEnum = "RAPIDFIRE",
    alternateAbilityEnum = nil,
    alternateQualifier = nil,
    modifiers = nil,
    combatStyle = "RANGED"
}
tooltipMetadata["Shadow Tendrils"] = {
    levelRequirement     = "75",
    adrenalineDelta      = "-",
    cooldownSeconds      = "45s",
    targetting           = "Single",
    targettingSprite     = id.Sprite.ABILITY_ICON_TOOLTIP_TARGET_SINGLE,
    abilityEnum          = "SHADOWTENDRILS",
    alternateAbilityEnum = nil,
    alternateQualifier   = nil,
    modifiers            = nil,
    combatStyle          = "RANGED"
}
tooltipMetadata["Corruption Shot"] = {
    levelRequirement = "70",
    adrenalineDelta = "-20%",
    cooldownSeconds = "15s",
    targetting = "Multi",
    targettingSprite = id.Sprite.ABILITY_ICON_TOOLTIP_TARGET_MULTIPLE,
    abilityEnum = "CORRUPTIONSHOT",
    alternateAbilityEnum = nil,
    alternateQualifier = nil,
    modifiers = nil,
    combatStyle = "RANGED"
}
tooltipMetadata["Galeshot"] = {
    levelRequirement = "58",
    adrenalineDelta = "9%",
    cooldownSeconds = "20.4s",
    targetting = "Single",
    targettingSprite = id.Sprite.ABILITY_ICON_TOOLTIP_TARGET_SINGLE,
    abilityEnum = "GALESHOT",
    alternateAbilityEnum = nil,
    alternateQualifier = nil,
    modifiers = nil,
    combatStyle = "RANGED"
}

return tooltipMetadata
