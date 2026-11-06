local modifierState           = require "state/modifierState"
local listenerResolver        = require "resolvers/modifierStateResolver"
local modifierPayloadResolver = require "resolvers/modifierPayloadResolver"
local equipmentContainer      = require "state/equipmentContainer"
local inventoryContainer      = require "state/inventoryContainer"
local inventoryStateResolver  = require "resolvers/inventoryStateResolver"
local json                    = require "lib/json"
local damageRequestBuilder    = require "payload/damageRequestBuilder"
local statsResolver           = require "resolvers/statsResolver"
local damageRequest           = require "payload/damageRequest"
local tooltipMetadata         = nil
local batchDamageRequest      = require "payload/batchDamageRequest"
local combatStyleLookup       = require "lookups/combatStyleLookup"
local payload                 = nil
local localCache              = {}
local cacheMisses             = 0
local cacheHits               = 0

local function decision(criterion1, modifierState)
    if criterion1 and not modifierState.status then
        modifierState.status = true
    elseif not criterion1 and modifierState.status then
        modifierState.status = false
    end
end

local function adjStacks(modifierState, stacks)
    modifierState.stacks = stacks
end

-- Listener for VarClient buffs
local function clientBuffListener(logicEvent)
    local logicTick = logicEvent.logicTick
    for index, value in pairs(modifierState) do
        if value.metadata.routing == "Client" then
            local buffActive = listenerResolver[value.metadata.routing](value, logicTick)
            decision(buffActive.status, value)
        end
    end
end
Event.Logic.Subscribe("clientBuffListener", clientBuffListener)

-- Listener for VarPlayer buffs
local function playerBuffListener()
    for index, value in pairs(modifierState) do
        if value.metadata.routing == "Client" then goto continue end
        local buffActive = listenerResolver[value.metadata.routing](value)
        decision(buffActive.status, value)
        adjStacks(value, buffActive.stacks)
        ::continue::
    end
end
Event.ServerLogic.Subscribe("playerBuffListener", playerBuffListener)

-- Listener for worn equipment and inventory
local function inventoryListener()
    inventoryStateResolver.resolve(1, 19, "WORN", equipmentContainer, "equipment")
    inventoryStateResolver.resolve(1, 28, "INV", inventoryContainer, "inventory")
    tooltipMetadata = require "metadata/tooltipMetadata"
end
Event.ServerLogic.Subscribe("inventoryListener", inventoryListener)

-- Listener for user stats
local function statListener()
    statsResolver.resolve()
end
Event.ServerLogic.Subscribe("statListener", statListener)

-- Payload listener
local function payloadListener()
    modifierPayloadResolver.resolve()
    damageRequestBuilder.build()
end
Event.ServerLogic.Subscribe("payloadListener", payloadListener)

local function getTooltipHoverPosition(mouseX, mouseY, component, layer)
    local position = {}
    local tooltipX = 0
    local tooltipY = 0
    local cursorGap = 30
    if mouseX ~= nil and mouseY ~= nil then
        local interfaceScale = math.min(200, game.options.InterfaceScale.setting)
        mouseX = mouseX / (interfaceScale / 100.0)
        mouseY = mouseY / (interfaceScale / 100.0)
        if mouseX < component.width / 2 then
            tooltipX = 0
        elseif mouseX > layer.width - component.width / 2 then
            tooltipX = layer.width - component.width
        else
            tooltipX = mouseX - component.width / 2
        end

        if mouseY > component.height + cursorGap then
            tooltipY = mouseY - component.height - cursorGap
        else
            tooltipY = mouseY + cursorGap
        end
    end
    position.x = tooltipX
    position.y = tooltipY
    return position
end

local tooltipBox              = nil
local abilityHeader           = nil
local damageCoeff             = nil
local damageOutput            = nil
local abilityName             = nil
local abilityIcon             = nil
local hitCount                = nil
local tooltipAbilityName      = nil
local modifierComponentsTable = {}

local function tooltipRenderer(drawEvent)
    local gameTooltip = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2_ABILITY_BOOK_TOOLTIP__MAIN_LAYER)
    local pluginLayer = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    local mouseX = Mouse.GetX()
    local mouseY = Mouse.GetY()
    if gameTooltip ~= nil and tooltipBox == nil then
        tooltipAbilityName = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2_ABILITY_BOOK_TOOLTIP__NAME_TEXT)
            .content
        if tooltipMetadata ~= nil and tooltipMetadata[tooltipAbilityName] then
            local tooltipBoxHeight = 140
            local abilityHeaderHeight = tooltipBoxHeight * 0.4
            local metadataRowHeight = tooltipBoxHeight * 0.25
            local divider = nil

            gameTooltip.hidden = true
            tooltipBox = ui.Layer.new(pluginLayer)

            if tooltipMetadata[tooltipAbilityName].modifiers == nil then
                tooltipBoxHeight = tooltipBoxHeight * 0.65
                abilityHeaderHeight = tooltipBoxHeight * 0.615
                metadataRowHeight = tooltipBoxHeight * 0.385
            else
                divider = ui.Line.new(tooltipBox)
            end

            tooltipBox:SetSize(324, tooltipBoxHeight)

            local background = ui.Rectangle.new(tooltipBox)
            background:SetSize(tooltipBox.width - 20, tooltipBox.height - 10)
            background.colour = Vector4.new(0.05, 0.05, 0.05, 1.0)
            background.fill = true
            background:SetY(0, 0.5, 0.5)
            background:SetX(0, 0.5, 0.5)
            background:MoveToBack()

            if divider ~= nil then
                divider:SetSize(background.width - 12, 0)
                divider.rgba = 0xF0BE7955
                divider:SetY(0, 0.4, 0.5)
                divider:SetX(0, 0.5, 0.5)
            end

            local borderWidth = 8
            local goldBarWidth = borderWidth - 2
            local goldCornerWidth = borderWidth - 1

            local topBorder = ui.Sprite.new(tooltipBox)
            topBorder:SetSize(background.width - 6, borderWidth)
            topBorder.sprite = id.Sprite.AIF_OVERLAY_FRAME_GOLD_CORNER_1_0
            topBorder:SetY(0, (goldBarWidth / tooltipBox.height), 0.5)
            topBorder:SetX(0, 0.5, 0.5)

            local bottomBorder = ui.Sprite.new(tooltipBox)
            bottomBorder:SetSize(background.width - 6, borderWidth)
            bottomBorder.rotationDegrees = 180
            bottomBorder.sprite = id.Sprite.AIF_OVERLAY_FRAME_GOLD_CORNER_1_0
            bottomBorder:SetY(0, 1 - (goldBarWidth / tooltipBox.height), 0.5)
            bottomBorder:SetX(0, 0.5, 0.5)

            local leftBorder = ui.Sprite.new(tooltipBox)
            leftBorder:SetSize(borderWidth, background.height - 6)
            leftBorder.sprite = id.Sprite.AIF_OVERLAY_FRAME_GOLD_CORNER_1_2
            leftBorder:SetY(0, 0.5, 0.5)
            leftBorder:SetX(0, (goldBarWidth / tooltipBox.width), 0.5)

            local rightBorder = ui.Sprite.new(tooltipBox)
            rightBorder:SetSize(background.height - 6, borderWidth)
            rightBorder.rotationDegrees = 90
            rightBorder.sprite = id.Sprite.AIF_OVERLAY_FRAME_GOLD_CORNER_1_0
            rightBorder:SetY(0, 0.5, 0.5)
            rightBorder:SetX(0, 1 - (goldBarWidth / tooltipBox.width), 0.5)

            local topLeftBorder = ui.Sprite.new(tooltipBox)
            topLeftBorder:SetSize(borderWidth, borderWidth)
            topLeftBorder.rotationDegrees = 90
            topLeftBorder.sprite = id.Sprite.AIF_OVERLAY_FRAME_GOLD_CORNER_1_1
            topLeftBorder:SetY(0, ((borderWidth - goldBarWidth) / tooltipBox.height), 0)
            topLeftBorder:SetX(0, (goldCornerWidth / tooltipBox.width), 0)

            local topRightBorder = ui.Sprite.new(tooltipBox)
            topRightBorder:SetSize(borderWidth, borderWidth)
            topRightBorder.sprite = id.Sprite.AIF_OVERLAY_FRAME_GOLD_CORNER_1_1
            topRightBorder:SetY(0, ((borderWidth - goldBarWidth) / tooltipBox.height), 0)
            topRightBorder:SetX(0, 1 - (goldCornerWidth / tooltipBox.width), 1)

            local bottomRightBorder = ui.Sprite.new(tooltipBox)
            bottomRightBorder:SetSize(borderWidth, borderWidth)
            bottomRightBorder.rotationDegrees = 270
            bottomRightBorder.sprite = id.Sprite.AIF_OVERLAY_FRAME_GOLD_CORNER_1_1
            bottomRightBorder:SetY(0, 1 - ((borderWidth - goldBarWidth) / tooltipBox.height), 1)
            bottomRightBorder:SetX(0, 1 - (goldCornerWidth / tooltipBox.width), 1)

            local bottomLeftBorder = ui.Sprite.new(tooltipBox)
            bottomLeftBorder:SetSize(borderWidth, borderWidth)
            bottomLeftBorder.rotationDegrees = 180
            bottomLeftBorder.sprite = id.Sprite.AIF_OVERLAY_FRAME_GOLD_CORNER_1_1
            bottomLeftBorder:SetY(0, 1 - ((borderWidth - goldBarWidth) / tooltipBox.height), 1)
            bottomLeftBorder:SetX(0, (goldCornerWidth / tooltipBox.width), 0)

            abilityHeader = ui.Layer.new(tooltipBox)
            abilityHeader:SetSize(background.width, abilityHeaderHeight)
            abilityHeader:SetY(5)
            abilityHeader:SetX(0, 0.5, 0.5)

            abilityIcon = ui.Sprite.new(abilityHeader)
            abilityIcon:SetSize(36, 36)
            abilityIcon:SetY(6, 0, 0)
            abilityIcon:SetX(6, 0, 0)

            local abilityHeaderRow1 = ui.Layer.new(abilityHeader)
            abilityHeaderRow1:SetSize(abilityHeader.width - abilityIcon.width - 6, abilityHeader.height / 2)
            abilityHeaderRow1:SetY(0, 0, 0)
            abilityHeaderRow1:SetX(abilityIcon.width + 6)

            abilityName = ui.Text.new(abilityHeaderRow1)
            abilityName:SetSize(100, 1)
            abilityName:SetY(6, 0, 0)
            abilityName:SetX(6, 0, 0)
            abilityName.font = 210
            abilityName.rgba = 0xF0BE79FF

            damageOutput = ui.Text.new(abilityHeaderRow1)
            damageOutput:SetSize(100, 1)
            damageOutput:SetY(0, 1, 1)
            damageOutput:SetX(-6, 1.0, 1.0)
            damageOutput.font = 211
            damageOutput.rgba = 0x25AD37FF
            damageOutput:AlignTo(ui.AlignMode.BOTTOMRIGHT)

            local abilityHeaderRow2 = ui.Layer.new(abilityHeader)
            abilityHeaderRow2:SetSize(abilityHeader.width - abilityIcon.width - 6, abilityHeader.height / 2)
            abilityHeaderRow2:SetY(0, 1, 1)
            abilityHeaderRow2:SetX(abilityIcon.width + 6)

            damageCoeff = ui.Text.new(abilityHeaderRow2)
            damageCoeff:SetSize(100, 1)
            damageCoeff:SetY(0, 0, 0)
            damageCoeff:SetX(6, 0, 0)
            damageCoeff.font = 207
            damageCoeff.rgba = 0xe6e6e6fc

            hitCount = ui.Text.new(abilityHeaderRow2)
            hitCount:SetSize(100, 1)
            hitCount:SetY(2, 0.5, 0.5)
            hitCount:SetX(-6, 1, 1)
            hitCount.font = 207
            hitCount.rgba = 0xe6e6e6fc
            hitCount:AlignTo(ui.AlignMode.BOTTOMRIGHT)

            local metadataRow = ui.Layer.new(tooltipBox)
            metadataRow:SetSize(background.width, metadataRowHeight)
            if tooltipMetadata[tooltipAbilityName].modifiers == nil then
                metadataRow:SetY(-2, 1, 1)
            else
                metadataRow:SetY(2, 0.5, 0.5)
            end

            metadataRow:SetX(0, 0.5, 0.5)

            local levelContainer = ui.Layer.new(metadataRow)
            levelContainer:SetSize(metadataRow.width / 4, metadataRow.height)
            levelContainer:SetY(0, 0.5, 0.5)
            levelContainer:SetX(0, 0, 0)

            local levelText = ui.Text.new(levelContainer)
            levelText:SetSize(24, 24)
            if tooltipMetadata ~= nil then
                levelText.content = tooltipMetadata[tooltipAbilityName].levelRequirement
            end
            levelText:SetY(0, 0.5, 0.5)
            levelText:SetX(0, 0.5, 0)
            levelText.font = 209
            levelText:AlignTo(ui.AlignMode.CENTRE)
            levelText.colour = Vector4.new(255, 255, 255, 0.8)

            local levelSprite = ui.Sprite.new(levelContainer)
            levelSprite:SetSize(24, 24)
            levelSprite.sprite = id.Sprite.STATICONS_3
            levelSprite:SetY(0, 0.5, 0.5)
            levelSprite:SetX(0, 0.15, 0)

            local adrenalineContainer = ui.Layer.new(metadataRow)
            adrenalineContainer:SetSize(metadataRow.width / 4, metadataRow.height)
            adrenalineContainer:SetY(0, 0.5, 0.5)
            adrenalineContainer:SetX(0, 0.25, 0)

            local adrenalineText = ui.Text.new(adrenalineContainer)
            adrenalineText:SetSize(24, 24)
            if tooltipMetadata ~= nil then
                adrenalineText.content = tooltipMetadata[tooltipAbilityName].adrenalineDelta
            end
            adrenalineText:SetY(0, 0.5, 0.5)
            adrenalineText:SetX(0, 0.5, 0)
            adrenalineText.font = 209
            adrenalineText:AlignTo(ui.AlignMode.CENTRE)
            adrenalineText.colour = Vector4.new(255, 255, 255, 0.8)

            local adrenalineSprite = ui.Sprite.new(adrenalineContainer)
            adrenalineSprite:SetSize(24, 24)
            adrenalineSprite.sprite = id.Sprite.COMBATV2_ATTRIBUTE_REQUIREMENT_ICONS_5
            adrenalineSprite:SetY(0, 0.5, 0.5)
            adrenalineSprite:SetX(0, 0.15, 0)

            local cooldownContainer = ui.Layer.new(metadataRow)
            cooldownContainer:SetSize(metadataRow.width / 4, metadataRow.height)
            cooldownContainer:SetY(0, 0.5, 0.5)
            cooldownContainer:SetX(0, 0.5, 0)

            local cooldownText = ui.Text.new(cooldownContainer)
            cooldownText:SetSize(24, 24)
            if tooltipMetadata ~= nil then
                cooldownText.content = tooltipMetadata[tooltipAbilityName].cooldownSeconds
            end
            cooldownText:SetY(0, 0.5, 0.5)
            cooldownText:SetX(0, 0.5, 0)
            cooldownText.font = 209
            cooldownText:AlignTo(ui.AlignMode.CENTRE)
            cooldownText.colour = Vector4.new(255, 255, 255, 0.8)

            local cooldownSprite = ui.Sprite.new(cooldownContainer)
            cooldownSprite:SetSize(24, 24)
            cooldownSprite.sprite = id.Sprite.RS3_ICON_SAND_TIMER
            cooldownSprite:SetY(0, 0.5, 0.5)
            cooldownSprite:SetX(0, 0.15, 0)

            local targetTypeContainer = ui.Layer.new(metadataRow)
            targetTypeContainer:SetSize(metadataRow.width / 4, metadataRow.height)
            targetTypeContainer:SetY(0, 0.5, 0.5)
            targetTypeContainer:SetX(0, 0.75, 0)

            local targetTypeText = ui.Text.new(targetTypeContainer)
            targetTypeText:SetSize(24, 24)
            if tooltipMetadata ~= nil then
                targetTypeText.content = tooltipMetadata[tooltipAbilityName].targetting
            end
            targetTypeText:SetY(0, 0.5, 0.5)
            targetTypeText:SetX(0, 0.5, 0)
            targetTypeText.font = 209
            targetTypeText:AlignTo(ui.AlignMode.CENTRE)
            targetTypeText.colour = Vector4.new(255, 255, 255, 0.8)

            local targetTypeSprite = ui.Sprite.new(targetTypeContainer)
            targetTypeSprite:SetSize(24, 24)
            if tooltipMetadata ~= nil then
                targetTypeSprite.sprite = tooltipMetadata[tooltipAbilityName].targettingSprite
            end
            targetTypeSprite:SetY(0, 0.5, 0.5)
            targetTypeSprite:SetX(0, 0.15, 0)

            local divider2 = ui.Line.new(tooltipBox)
            divider2:SetSize(background.width - 12, 0)
            divider2.rgba = 0xF0BE7955
            divider2:SetY(0, 0.625, 0.5)
            divider2:SetX(0, 0.5, 0.5)

            local modifiersRow = nil

            if tooltipMetadata ~= nil then
                local modifierCount = 0

                if tooltipMetadata[tooltipAbilityName].modifiers ~= nil then
                    modifierCount = 1
                    for index, value in pairs(tooltipMetadata[tooltipAbilityName].modifiers) do
                        modifierCount = modifierCount + 1
                    end

                    modifiersRow = ui.Layer.new(tooltipBox)
                    modifiersRow:SetSize(background.width, background.height * 0.35)
                    modifiersRow:SetY(-6, 1.0, 1.0)
                    modifiersRow:SetX(0, 0.5, 0.5)

                    local gapNumerator = 1
                    for index, modifier in pairs(tooltipMetadata[tooltipAbilityName].modifiers) do
                        local modifierContainer = ui.Layer.new(modifiersRow)
                        local modifierSprite = ui.Sprite.new(modifierContainer)
                        local modifierLabel = ui.Text.new(modifierContainer)
                        local modifierRankSprite = ui.Sprite.new(modifierContainer)
                        local gap = gapNumerator / (modifierCount)
                        modifierContainer:SetSize(modifiersRow.width / modifierCount, modifiersRow.height)
                        modifierContainer:SetY(0, 0.5, 0.5)
                        modifierContainer:SetX(0, gap, 0.5)
                        modifierSprite:SetSize(24, 24)
                        modifierSprite:SetY(4, 0, 0)
                        modifierSprite:SetX(0, 0.5, 0.5)
                        modifierRankSprite:SetSize(24, 24)
                        modifierRankSprite:SetY(4, 0, 0)
                        modifierRankSprite:SetX(0, 0.5, 0.5)
                        modifierLabel:SetSize(24, 24)
                        modifierLabel:SetY(4, 1, 1)
                        modifierLabel:SetX(0, 0.5, 0.5)
                        modifierLabel.font = 207
                        modifierLabel:AlignTo(ui.AlignMode.CENTRE)

                        modifierComponentsTable[index] = {}
                        modifierComponentsTable[index].modifierSprite = modifierSprite
                        modifierComponentsTable[index].modifierLabel = modifierLabel
                        modifierComponentsTable[index].modifierRankSprite = modifierRankSprite

                        gapNumerator = gapNumerator + 1
                    end
                end
            end
        else
            local tooltipPosition = getTooltipHoverPosition(mouseX, mouseY, gameTooltip, pluginLayer)
            gameTooltip:SetPos(tooltipPosition.x, tooltipPosition.y)
        end
    end

    if gameTooltip ~= nil and tooltipBox ~= nil then
        local tooltipPosition = getTooltipHoverPosition(mouseX, mouseY, tooltipBox, pluginLayer)
        tooltipBox:SetPos(tooltipPosition.x, tooltipPosition.y)

        local enum = nil
        if tooltipMetadata ~= nil then
            enum = damageRequestBuilder.buildAbilityId(tooltipAbilityName)
        end

        local content = nil
        if payload ~= nil then
            content = localCache[payload]
        end

        if damageCoeff ~= nil then
            if content ~= nil and content[enum] ~= nil and content[enum].minCoeff ~= nil and content[enum].maxCoeff ~= nil then
                damageCoeff.content = math.tointeger(content[enum].minCoeff) ..
                    "% - " .. math.tointeger(content[enum].maxCoeff) .. "%"
            end
        end

        if damageOutput ~= nil then
            if content ~= nil and content[enum] ~= nil and content[enum].nonCritMin ~= nil then
                damageOutput.content = string.gsub(tostring(math.tointeger(content[enum].nonCritMin)),
                    "^(-?%d+)(%d%d%d)",
                    '%1,%2')
            end
        end

        if hitCount ~= nil then
            if content ~= nil and content[enum] ~= nil and content[enum].hits ~= nil then
                hitCount.content = content[enum].hits .. " Hits"
            end
        end

        if abilityName ~= nil then
            abilityName.content = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2_ABILITY_BOOK_TOOLTIP__NAME_TEXT)
                .content
        end

        if abilityIcon ~= nil then
            abilityIcon.sprite = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2_ABILITY_BOOK_TOOLTIP__ICON).sprite
        end

        if tooltipMetadata ~= nil then
            for component, value in pairs(modifierComponentsTable) do
                if tooltipMetadata[tooltipAbilityName].modifiers[component] ~= nil then
                    local modifierResult = tooltipMetadata[tooltipAbilityName].modifiers[component](modifierState,
                        equipmentContainer)

                    value.modifierSprite.sprite = modifierResult.sprite
                    value.modifierLabel.content = modifierResult.label

                    if modifierResult.rankSprite ~= nil then
                        value.modifierRankSprite.sprite = id.Sprite[modifierResult.rankSprite]
                    end

                    if modifierResult.active then
                        value.modifierLabel.colour = Vector4.new(1, 1, 1, 1)
                        value.modifierSprite.colour = Vector4.new(1, 1, 1, 1)
                        value.modifierRankSprite.colour = Vector4.new(1, 1, 1, 1)
                    else
                        value.modifierLabel.colour = Vector4.new(1, 1, 1, 0.35)
                        value.modifierSprite.colour = Vector4.new(1, 1, 1, 0.35)
                        value.modifierRankSprite.colour = Vector4.new(1, 1, 1, 0.35)
                    end
                end
            end
        end
    end

    if tooltipBox ~= nil and gameTooltip == nil then
        tooltipBox:Destroy()
        tooltipBox = nil
        damageCoeff = nil
        damageOutput = nil
        abilityName = nil
        abilityIcon = nil
        hitCount = nil
        modifierComponentsTable = {}
    end
end
Event.Draw.Subscribe("tooltipRenderer", tooltipRenderer)

local sent = false
local function request()
    local previousPayload = payload
    local abilityIds = {}
    batchDamageRequest.base = damageRequest

    if tooltipMetadata ~= nil then
        local combatStyle = var.VarPlayer.COMBATV2_MAINHAND_STYLE.value
        for index, metadata in pairs(tooltipMetadata) do
            if metadata.combatStyle ~= nil and metadata.combatStyle ~= 7 and combatStyleLookup[metadata.combatStyle] ~= nil then
                local combatStyleMatch = false
                for index, value in pairs(combatStyleLookup[metadata.combatStyle]) do
                    if value == combatStyle then combatStyleMatch = true end
                end

                if combatStyleMatch then
                    local enum = damageRequestBuilder.buildAbilityId(index)
                    if enum ~= nil then
                        table.insert(abilityIds, enum)
                    end
                end
            end
        end
    end

    table.sort(abilityIds)

    batchDamageRequest.abilityIds = abilityIds
    payload = json.encode(batchDamageRequest)

    if payload ~= previousPayload then
        sent = false
    end

    if tooltipBox ~= nil and not sent then
        if localCache[payload] == nil then
            sent = true
            local payload = json.encode(batchDamageRequest)
            local request = HTTPRequest.new(Plugin.urls.rotdb, "/damage/calculate/batch-base-damage-present")
            request:AddHeader("Content-Type", "application/json")
            request:Post(payload, function(request)
                if request.successful then
                    if localCache[payload] == nil then
                        local damageResult = json.decode(request.data)
                        if payload ~= nil then
                            localCache[payload] = damageResult
                        end
                    end
                    cacheMisses = cacheMisses + 1
                    print("Cache misses:", cacheMisses)
                elseif request.timedOut then
                    print(request.url, "request timed out")
                elseif request.failed then
                    print(request.url, "request failed, error code =", request.responseCode)
                end
            end)
        else
            sent = true
            cacheHits = cacheHits + 1
            print("Cache hits:", cacheHits)
        end
    end
end
Event.Draw.Subscribe("request", request)
