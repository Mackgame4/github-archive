SETTINGS_OPEN = false
HUD_HIDDEN = false
HUD_PAUSE_HIDE = false
HUD_CINEMATIC = false
HUD_DETAILS = false

function OnComponentUpdate(c)
    ToggleHUDHidden(true)
end

-- AddEventHandler('ARP:Shared:Components:RegisterReady', function(resource)
--     if resource == GetCurrentResourceName() or resource == 'all' then 
--         --exports['arp-base']:RegisterComponent('HUD', COMPONENT)
--     end
-- end)

function OnCharacterLoad()
    ToggleHUDHidden(false)
    UpdateRadarState()
    ParseSavedHUDSettings()
end

function OnCharacterUnload()
    ToggleHUDHidden(true)
    UpdateRadarState()
end

-- IsPauseMenuActive()

Citizen.CreateThread(function()
    DisplayRadar(false)
    UpdateRadarTopPosition()
    while true do 
        if CHAR_LOADED then
            sendNUI('dataUpdates', {
                vehicle = GetHUDVehicleData(),
                location = GetLocationData(),
                limbDamage = GetCharacterDamage(),
                stats = GetCharacterStats(),
            })
            --UpdateRadarState()
            if not HUD_HIDDEN and IsPauseMenuActive() then 
                HUD_PAUSE_HIDE = true
                ToggleHUDHidden(IsPauseMenuActive())
            elseif HUD_PAUSE_HIDE and not IsPauseMenuActive() then 
                HUD_PAUSE_HIDE = false
                ToggleHUDHidden(false)
            end
        else 
            Citizen.Wait(2000) 
        end
        Citizen.Wait(400)
    end
end)

function ToggleHUDHidden(state)
    HUD_HIDDEN = state
    sendNUI('forceHideState', HUD_HIDDEN)
    UpdateRadarState()
end

function ToggleHUDCinematic(state)
    if HUD_CINEMATIC ~= state then 
        HUD_CINEMATIC = state
        sendNUI('toggleCinematicMode', HUD_CINEMATIC)
        UpdateRadarState()
    end
end

function UpdateRadarState()
    if CHAR_LOADED and VEHICLE_INSIDE and not HUD_SETTINGS.hideMinimap and not HUD_CINEMATIC and not HUD_HIDDEN then 
        DisplayRadar(true)
    else
        DisplayRadar(false)
    end
    UpdateRadarTopPosition()
end

function ToggleDetailState(state)
    if HUD_DETAILS ~= state then 
        HUD_DETAILS = state
        sendNUI('toggleDetailState', HUD_DETAILS)
    end
end

RegisterNUICallback('toggleCinematic', function(data, cb)
    ToggleHUDCinematic(data)
    cb('ok')
end)

RegisterNUICallback('toggleHidden', function(data, cb)
    ToggleHUDHidden(data)
    cb('ok')
end)

function UpdateRadarTopPosition()
    SetScriptGfxAlign(string.byte('L'), string.byte('B'))
    local minimapTopX, minimapTopY = GetScriptGfxPosition(-0.0045, 0.002 + (-0.188888))
    ResetScriptGfxAlign()
    local w, h = GetActiveScreenResolution()
    sendNUI('updateStatLocation', { 
        left = w * minimapTopX,
        bottom = IsRadarHidden() and 10 or h - (h * minimapTopY)
    })
end