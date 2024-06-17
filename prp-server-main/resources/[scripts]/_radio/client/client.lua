RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

local radioMenu = false
function enableRadio(enable)
    SetNuiFocus(true, true)
    radioMenu = enable
    SendNUIMessage({
        type = "enableui",
        enable = enable
    })
end

if Debug then
    RegisterCommand('radio', function(source, args)
        if Config.EnableCommand then
            enableRadio(true)
        end
    end, false)
end

local lastChannel = nil
RegisterNUICallback('joinRadio', function(data, cb)
    local _source = source
    local PlayerData = ESX.GetPlayerData(_source)
    local playerName = GetPlayerName(PlayerId())
    if lastChannel == nil then
        if tonumber(data.channel) <= Config.RestrictedChannels then
            if (PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'fire') then
                lastChannel = data.channel
                exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
                exports["pma-voice"]:setRadioChannel(tonumber(data.channel))
                TriggerEvent('_drawtextui:ShowNotify', 'info', 2000, 'You joined the radio: '.. data.channel .. '.00 MHz')
            elseif not (PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'fire') then
                TriggerEvent('_drawtextui:ShowNotify', 'error', 2000, 'You can not join encrypted channels!')
            end
        elseif tonumber(data.channel) > Config.RestrictedChannels then
            lastChannel = data.channel
            exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
            exports["pma-voice"]:setRadioChannel(tonumber(data.channel))
            TriggerEvent('_drawtextui:ShowNotify', 'info', 2000, 'You joined the radio: '.. data.channel .. '.00 MHz')
        end
    end
    cb('ok')
end)

RegisterNUICallback('leaveRadio', function(data, cb)
    exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
    exports["pma-voice"]:setRadioChannel(0)
    if lastChannel ~= nil then
        TriggerEvent('_drawtextui:ShowNotify', 'error', 2000, 'You exited the radio: '.. lastChannel .. '.00 MHz')
        lastChannel = nil
    end
    cb('ok')
end)

RegisterNUICallback('escape', function(data, cb)
    enableRadio(false)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNetEvent('_radio:use')
AddEventHandler('_radio:use', function()
    enableRadio(true)
end)