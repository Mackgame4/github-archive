COMPONENTS = {}
COMPONENTS_REQUIRED = { 'Logging', 'API', 'Base', 'DB', 'Users', 'Callbacks', 'Store' }

ENVIRONMENT = {
    TYPE = 'development',
    APIKEY = {},
    LOADED = false,
}

COMPONENTS.Base = {
    _protected = true,
    IsInDev = function(self)
        return ENVIRONMENT.TYPE == 'development'
    end,
}

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Citizen.CreateThread(function()
            repeat Wait(10) until exports and exports[GetCurrentResourceName()] ~= nil
            repeat Wait(100) until exports['arp-mongodb'] and exports['arp-mongodb']:isConnected()
            Citizen.Wait(1000)
            TriggerEvent('ARP:Shared:Components:Init')
            repeat Wait(500) until AreComponentsLoaded(COMPONENTS_REQUIRED)
            Citizen.Wait(1000)
            local apiConnection = COMPONENTS.API:Init()
            if apiConnection and apiConnection.active then
                ENVIRONMENT.TYPE = apiConnection.environment
                ENVIRONMENT.APIKEY.id = apiConnection.keyID
                ENVIRONMENT.APIKEY.name = apiConnection.keyName
                COMPONENTS.Logging:Info('ARP', 'API Key Validated - Used API Key: "' .. ENVIRONMENT.APIKEY.name .. '"', { skipDiscord = true })
                if COMPONENTS.Base:IsInDev() then
                    local developer = GetConvar('arp_developer', 'Test Server')
                    SetConvar('sv_hostname', 'ARP - AuthenticRP.com - Development Server - ' .. developer)
                else
                    SetConvar('sv_hostname', 'ARP - AuthenticRP.com - Production Server')
                end
                COMPONENTS.Logging:Info('ARP', 'Server Started '.. (COMPONENTS.Base:IsInDev() and '[Development Mode]' or ''))

                GlobalState.ARP = {
                    mode = ENVIRONMENT.ENV,
                    loaded = true,
                    development = COMPONENTS.Base:IsInDev()
                }

                GlobalState.UserCount = 0
                GlobalState.UserMax = tonumber(GetConvar('sv_maxclients', '48'))

                TriggerEvent('ARP:Shared:Ready', 'all')
            else
                Citizen.Wait(1)
                os.exit()
            end
        end)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then 
        GlobalState.ARP = {
            loaded = false
        }
    end
end)