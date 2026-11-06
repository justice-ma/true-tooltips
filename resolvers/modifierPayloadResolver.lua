local modifierState = require "state/modifierState"
local inventory = require "state/inventoryContainer"
local modifierPayload = require "state/modifierPayload"

local function shouldBeAddedToPayload(modifier, category)
    return
        modifier.status and
        modifier.metadata.enum ~= "PUZZLEBOX" and
        modifier.metadata.enum ~= nil and
        modifier.metadata.category == category
end

local payloadStateResolver = {
    resolve = function()
        local previousTickPayload = {}
        for index, value in pairs(modifierPayload) do
            previousTickPayload[index] = value
            modifierPayload[index] = {}
        end
        modifierPayload.itemLevel20.active = false

        local puzzleboxTier = 0
        if modifierState.puzzleboxToolbelt.status or inventory.inventory["SEASON2022_INFERNUS_PUZZLE_BOX"] then
            if modifierState.puzzlebox2.status then puzzleboxTier = 2 end
            if modifierState.puzzlebox3.status then puzzleboxTier = 3 end
            if modifierState.puzzlebox4.status then puzzleboxTier = 4 end
            if modifierState.puzzlebox5.status then puzzleboxTier = 5 end
            if modifierState.puzzlebox6.status then puzzleboxTier = 6 end
        end

        if puzzleboxTier ~= 0 then
            modifierPayload.buffStacks.PUZZLEBOX = puzzleboxTier
        end

        if (modifierState.fulBookActive.status or modifierState.amascutBookActive.status) and
            modifierState.bookActive.status then
            modifierPayload.buffStacks.BOOKUPTIME = 100
        else
            modifierPayload.buffStacks.BOOKUPTIME = 0
        end

        for index, value in pairs(modifierState) do
            if value.metadata.stackable and shouldBeAddedToPayload(value, "BuffId") then
                modifierPayload.buffStacks[value.metadata.enum] = value.stacks
            elseif (not value.metadata.stackable) and shouldBeAddedToPayload(value, "BuffId") then
                modifierPayload.buffs[value.metadata.enum] = true
            elseif (not value.metadata.stackable) and shouldBeAddedToPayload(value, "Prayer") then
                modifierPayload.prayers[value.metadata.enum] = true
            elseif value.metadata.category == "Prayer" and value.metadata.enum == nil and value.status then
                local prayerLevel = Player.GetLevelCapped(5)
                local strengthEnum = nil

                if index == "boostMeleeStrength" then
                    if prayerLevel >= 4 then strengthEnum = "BURSTOFSTRENGTH" end
                    if prayerLevel >= 13 then strengthEnum = "SUPERHUMANSTRENGTH" end
                    if prayerLevel >= 31 then strengthEnum = "ULTIMATESTRENGTH" end
                elseif index == "boostRangedStrength" then
                    if prayerLevel >= 8 then strengthEnum = "UNSTOPPABLEFORCE" end
                    if prayerLevel >= 26 then strengthEnum = "UNRELENTINGFORCE" end
                    if prayerLevel >= 44 then strengthEnum = "OVERPOWERINGFORCE" end
                elseif index == "boostMagicStrength" then
                    if prayerLevel >= 9 then strengthEnum = "CHARGE" end
                    if prayerLevel >= 27 then strengthEnum = "SUPERCHARGE" end
                    if prayerLevel >= 45 then strengthEnum = "OVERCHARGE" end
                elseif index == "boostNecromancyStrength" then
                    if prayerLevel >= 10 then strengthEnum = "DECAY" end
                    if prayerLevel >= 28 then strengthEnum = "HASTENEDDECAY" end
                    if prayerLevel >= 46 then strengthEnum = "ACCELERATEDDECAY" end
                end

                if strengthEnum ~= nil then
                    modifierPayload.prayers[strengthEnum] = true
                end
            elseif shouldBeAddedToPayload(value, "Perk") then
                modifierPayload.selectedPerks[value.metadata.enum] = value.stacks
                if value.metadata.itemLevelCheckPath ~= nil and value.metadata.itemLevelCheckPath.value == 1 then
                    modifierPayload.itemLevel20.active = true
                end

                if value.metadata.enum == "GENOCIDAL" then
                    local originalKillsLeft = var.VarPlayer.SS_ORIGINAL_COUNT.value
                    local currentKillsLeft = var.VarPlayer.SLAYER_COUNT.value
                    local modifier = 0

                    if originalKillsLeft ~= 0 then
                        modifier = 1 / 10.0 * math.floor(5 * (1 - currentKillsLeft / originalKillsLeft) * 10)
                    end

                    modifierPayload.genocidal.modifier = modifier
                end
            end
        end

        -- for payloadTable, payloadObject in pairs(modifierPayload) do
        --     for modifier, value in pairs(previousTickPayload[payloadTable]) do
        --         if not modifierPayload[payloadTable][modifier] then
        --             print("Modifier removed:", modifier)
        --         elseif modifierPayload[payloadTable][modifier] ~= value then
        --             print(modifier, value, " -> ", modifierPayload[payloadTable][modifier])
        --         end
        --     end

        --     for modifier, value in pairs(payloadObject) do
        --         if not previousTickPayload[payloadTable][modifier] then
        --             if payloadTable == "buffStacks" or payloadTable == "perks" then
        --                 print("Modifier added:", modifier, value)
        --             else
        --                 print("Modifier added:", modifier)
        --             end
        --         end
        --     end
        -- end
    end
}

return payloadStateResolver
