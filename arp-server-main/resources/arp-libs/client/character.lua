CHAR_LOADED = false
CHAR_DATA = nil
CHAR_DEAD = false

RegisterNetEvent('Characters:Client:Login')
AddEventHandler('Characters:Client:Login', function(data) 
    if not CHAR_LOADED then 
        CHAR_DEAD = false
        CHAR_LOADED = true
        CHAR_DATA = data
        if OnCharacterLoad then OnCharacterLoad() end
    end
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function() 
    if CHAR_LOADED then 
        CHAR_DEAD = false
        CHAR_LOADED = false
        CHAR_DATA = nil
        if OnCharacterUnload then OnCharacterUnload() end
    end
end)

RegisterNetEvent('Characters:Client:Update')
AddEventHandler('Characters:Client:Update', function(k, v) 
    if CHAR_DATA ~= nil then 
        CHAR_DATA[k] = v
        if OnCharacterDataUpdate then OnCharacterDataUpdate(k, v) end
    end
end)


AddEventHandler('Medical:Client:DeadState', function(state)
    CHAR_DEAD = state
    if OnCharacterDeath then 
        OnCharacterDeath(CHAR_DEAD)
    end
end)

AddEventHandler('Characters:Client:FullyLoaded', function() -- Stuff has finished loaded and Ped has been set
    if CHAR_LOADED and OnCharacterLoadFull then 
        OnCharacterLoadFull()
    end
end)

-- ? This is only meant for when resources restarted, this makes development 10x easier.

Citizen.CreateThread(function()
    Citizen.Wait(2500)
    local Characters = exports['arp-base']:FetchComponent('Characters')
    if Characters == nil then return end
    local hasCurrent = Characters:Current()
    if hasCurrent and not CHAR_LOADED then 
        CHAR_LOADED = true
        CHAR_DATA = hasCurrent:GetData()
        if OnCharacterLoad then OnCharacterLoad() end
        if OnCharacterLoadFull then OnCharacterLoadFull() end
    end
end)