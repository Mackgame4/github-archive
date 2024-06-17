-- https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/

local keyMappings = {
    ['interactionPrimary'] = {
        description = 'Interaction - Primary',
        defaultKey = 'E',
        defaultPad = 'keyboard',
        event = true,
    },
    ['interactionModifier'] = {
        description = 'Interaction - Modifier',
        defaultKey = 'LSHIFT',
        defaultPad = 'keyboard',
        event = false,
        allowWhenDead = true,
    },
    ['interactionTargeting'] = {
        description = 'Interaction - Targeting (Hold)',
        defaultKey = 'LMENU',
        defaultPad = 'keyboard',
        event = true,
    },
    ['interactionCancel'] = {
        description = 'Cancel Your Current Task',
        defaultKey = 'X',
        defaultPad = 'keyboard',
        event = true,
    },
    ['vehicleLocking'] = {
        description = 'Vehicles - Lock/Unlock',
        defaultKey = 'G',
        defaultPad = 'keyboard',
        event = true,
    },
    ['vehicleToggleEngine'] = {
        description = 'Vehicles - Engine Toggle',
        defaultKey = 'Z',
        defaultPad = 'keyboard',
        event = true,
    },
    ['vehicleSeatbelt'] = {
        description = 'Vehicles - Seatbelt Toggle',
        defaultKey = 'B',
        defaultPad = 'keyboard',
        event = true,
    },
    ['phoneOpen'] = {
        description = 'Phone - Open Phone',
        defaultKey = 'f3',
        defaultPad = 'keyboard',
        event = true,
    },
    ['arp'] = {
        description = 'ARP Menu Shortcut',
        defaultKey = 'f1',
        defaultPad = 'keyboard',
        event = true,
        allowWhenDead = true,
    },
    ['HUDmapZoom'] = {
        description = 'HUD - Minimap Zoom Cycling',
        defaultKey = 'm',
        defaultPad = 'keyboard',
        event = true,
    },
    ['HUDshowDetails'] = {
        description = 'HUD - Show Details (HOLD)',
        defaultKey = 'TAB',
        defaultPad = 'keyboard',
        event = true,
        allowWhenDead = true,
    },
    ['HUDcinematic'] = {
        description = 'HUD - Cinematic Toggle',
        defaultKey = '',
        defaultPad = 'keyboard',
        event = true,
        allowWhenDead = true,
    },
    ['f6'] = {
        description = 'Actions - Vehicle',
        defaultKey = 'f6',
        defaultPad = 'keyboard',
        event = true,
    },
    ['doorLocks'] = {
        description = 'Doors - Lock/Unlock',
        defaultKey = 'l',
        defaultPad = 'keyboard',
        event = true,
    },
    ['f5'] = {
        description = 'Actions - Character',
        defaultKey = 'f5',
        defaultPad = 'keyboard',
        event = true,
        allowWhenDead = true,
    },
    ['inv_1'] = {
        description = 'Inventory - Use Slot 1',
        defaultKey = '1',
        defaultPad = 'keyboard',
        event = true,
    },
    ['inv_2'] = {
        description = 'Inventory - Use Slot 2',
        defaultKey = '2',
        defaultPad = 'keyboard',
        event = true,
    },
    ['inv_3'] = { -- 1
        description = 'Inventory - Use Slot 3',
        defaultKey = '3',
        defaultPad = 'keyboard',
        event = true,
    },
    ['inv_4'] = { -- 1
        description = 'Inventory - Use Slot 4',
        defaultKey = '4',
        defaultPad = 'keyboard',
        event = true,
    },
    ['inv_5'] = { -- 1
        description = 'Inventory - Use Slot 5',
        defaultKey = '5',
        defaultPad = 'keyboard',
        event = true,
    },
    ['emote_1'] = { -- 1
        description = 'Emotes - Favourite 1',
        defaultKey = '6',
        defaultPad = 'keyboard',
        event = true,
    },
    ['emote_2'] = { -- 1
        description = 'Emotes - Favourite 3',
        defaultKey = '7',
        defaultPad = 'keyboard',
        event = true,
    },
    ['emote_3'] = { -- 1
        description = 'Emotes - Favourite 4',
        defaultKey = '8',
        defaultPad = 'keyboard',
        event = true,
    },
    ['emote_4'] = { -- 1
        description = 'Emotes - Favourite 5',
        defaultKey = '9',
        defaultPad = 'keyboard',
        event = true,
    },
}

local disabledMappings = false
local disabledMappingsForPhone = false

Citizen.CreateThread(function()
    for trigger, data in pairs(keyMappings) do 
        local _down = '+' .. trigger
        local _up = '-' .. trigger
        RegisterCommand(_down, function() KeyMappingTrigger(trigger, true) end)
        RegisterCommand(_up, function() KeyMappingTrigger(trigger, false) end)
        RegisterKeyMapping(_down, data.description, data.defaultPad, data.defaultKey)
    end
end)

local holdingModifier = false

function KeyMappingTrigger(key, action) -- action = true if keydown
    if disabledMappings then
        if type(disabledMappings) == 'table' and ARP.DoesTableHaveValue(disabledMappings, key) then 
            return
        elseif type(disabledMappings) == 'boolean' then 
            return
        end
    end

    if disabledMappingsForPhone and key ~= 'phoneOpen' then 
        return
    end

    
    local keyData = keyMappings[key]
    
    if keyData then 
        if (not CHAR_DEAD) or (keyData.allowWhenDead and CHAR_DEAD) then 
            if key == 'interactionModifier' then 
                holdingModifier = action
            end
    
            if keyData.event then 
                if action then 
                    TriggerEvent('Interaction:KeyBindings:KeyDown', key, holdingModifier)
                else
                    TriggerEvent('Interaction:KeyBindings:KeyUp', key, holdingModifier)
                end
            end
        end
    end
end

function DisableKeyMappings(keys)
    if not keys then 
        disabledMappings = false
    else
        if type(keys) == 'string' then 
            keys = { keys }
        end
        disabledMappings = keys
    end
end

exports('DisableKeyMappings', DisableKeyMappings)

function DisableKeyMappingsForPhone(toggle)
    disabledMappingsForPhone = toggle
end

exports('DisableKeyMappingsForPhone', DisableKeyMappingsForPhone)