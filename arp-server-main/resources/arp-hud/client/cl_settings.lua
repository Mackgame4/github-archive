HUD_SETTINGS = {}
GEN_SETTINGS = {}

_defaultHUDSettings = {
    stats = {
        health = 75,
        hunger = 75,
        thirst = 75,
    },
    --hiddenStats = {}
    hideLocation = false,
    hideMinimap = false,
    hideAnatomy = 2,
    speedoDriver = true,
    speedoPassenger = true,
}

RegisterNetEvent('Hud:Client:OpenSettings')
AddEventHandler('Hud:Client:OpenSettings', function()
    if CHAR_LOADED and not SETTINGS_OPEN then 
        local data = Components.Callbacks:Execute('Admin:Server:GetPlayerMenuData')
        if data and data.recentDisconnects then
            sendNUI('updatePlayerData', data)
            SETTINGS_OPEN = true
            sendNUI('openMenu', {})
            SetNuiFocus(true, true)
        end
    end
end)

RegisterNUICallback('startClosingSettings', function(data, cb)
    if SETTINGS_OPEN then 
        SetNuiFocus(false, false)
        cb({ success = true })
        sendNUI('closeMenu')
        SETTINGS_OPEN = false
    end
end)

function ParseSavedHUDSettings() 
    local foundSettings = json.decode(GetResourceKvpString('ARP_HUD_SETTINGS'))
    if foundSettings == nil or type(foundSettings) ~= 'table' then 
        SaveHUDSettings(_defaultHUDSettings)
    else
        HUD_SETTINGS = foundSettings
    end
    sendNUI('updateHUDSettings', HUD_SETTINGS)
end

function SaveHUDSettings(settings)
    SetResourceKvp('ARP_HUD_SETTINGS', json.encode(settings))
    HUD_SETTINGS = settings

    UpdateRadarState()
end

function GetHUDSetting(key)
    if key == nil then 
        return HUD_SETTINGS
    else
        if HUD_SETTINGS[key] ~= nil then
            return HUD_SETTINGS[key]
        else
            return _defaultHUDSettings[key]
        end
    end
end

RegisterNUICallback('saveHUD', function(data, cb)
    SaveHUDSettings(data)
    cb({ success = true })
end)

RegisterNUICallback('staffExecuteCommand', function(d, cb)
    ExecuteCommand(d)
    cb('ok')
end)

RegisterNUICallback('clipboardCopy', function(d, cb)
    Components.UI:Copy(d)
    cb('ok')
end)

RegisterNUICallback('requestPlayerDataUpdate', function(d, cb)
    -- Refresh, Na maybe later
    cb('ok')
end)