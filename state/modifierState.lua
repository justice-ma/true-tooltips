local metadata = require "metadata/modifierMetadata"

--[[
    Contains metadata for all buffs currently tracked in damage calculation.

    Shape:
        metadata: Reference to the buff metadata in modifierMetadata.lua
        endTick: The ending tick for a timed buff, nil for VarPlayer
        status: Buff status boolean, true if active, false if inactive
        stacks: Stack count for the buff, nil if metadata.stackable ~= true

    endTick, status, and stacks are all populated in the listener
]]

local modifierState = {}
for index, value in pairs(metadata) do
    local metadata = value
    modifierState[index] = {
        metadata = metadata
    }
end

return modifierState
