-- Gathers base stats for crit damage modifiers

local statsContainer = require "state/statsContainer"

local statsResolver = {
    resolve = function()
        statsContainer.strength = Player.GetLevelCapped(2)
        statsContainer.ranged = Player.GetLevelCapped(4)
        statsContainer.magic = Player.GetLevelCapped(6)
        statsContainer.necromancy = Player.GetLevelCapped(28)
        statsContainer.currentHp = var.VarPlayer.LIFEPOINTS.value
        statsContainer.maxHp = var.VarPlayer.MAXLIFEPOINTS.value
    end
}

return statsResolver
