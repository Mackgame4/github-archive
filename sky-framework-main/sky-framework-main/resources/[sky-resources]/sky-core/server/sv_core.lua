Core.Internal = Core.Internal or {}

Core.Internal.Init = function(self)
    SetConvarReplicated('gamename', GetConvar('gamename', 'gta5'))
    Citizen.CreateThread(function()        
        while not exports or exports[GetCurrentResourceName()] == nil do
            Citizen.Wait(1)
        end
        Core.Modules.Logger:Info('Core', 'Server Starting Up')
    
        TriggerEvent('Database:Server:Initialize')
        while not Core.Modules.Proxy.DatabaseReady do
            Citizen.Wait(1)
        end
        Core.Modules.Functions:SetGame()
        Core.Modules.Logger:Info('Core', 'Server Configured for '..Core.Modules.Proxy.ServerMeta.GameName)
        TriggerEvent('Proxy:Shared:RegisterReady')
        Core.Modules.Logger:Info('Core', 'Accepting New Module Registrations')
        Citizen.Wait(1000)
        local totalModules = 0
        for k, v in pairs(Core.Modules) do TriggerEvent('Proxy:Shared:ExtendReady', k); totalModules = totalModules + 1 end
        Core.Modules.Logger:Info('Core', 'Allowing Modules to Settle...')
        Citizen.Wait(2000)
        Core.Modules.Logger:Success('Core', '[^2'..totalModules..'^7] Modules Registered and Extended')
        Core.Modules.Proxy.ExportsReady = true
        TriggerEvent('Proxy:Shared:ExportsReady')
        Citizen.Wait(1500)
        Core.Modules.Proxy.ScriptsReady = true
        TriggerEvent('Core:Shared:ScriptsReady')
        Wait(600)
        Core.Modules.Logger:Info('Core', 'Opening Queue To New Players')
        Wait(600)
        Core.Modules.Logger:Info('Core', 'Queue Now Accepting New Connections')
        Core.Modules.Proxy.QueueOpen = true
        Core.Modules.Proxy.QueueOpenTime = GetGameTimer()
        Citizen.Wait(100)
        Core.Modules.Logger:Success('Core', 'Server Startup Successful')
        return
    end)
end

Core.Internal.DatabaseReady = function(self, db)
    if db == nil then return end
    if Core.Modules.Database ~= nil then return end
    if Core.Modules.Database == nil and db ~= nil then Core.Modules.Database = db end
    Core.Modules.Proxy.DatabaseReady = true
    Core.Modules.Proxy.DatabaseReadyTime = GetGameTimer()
    Core.Modules.Logger:Success('Database', 'Database Successfully Connected')
    TriggerEvent('Core:Shared:Ready')
    return
end

AddEventHandler('Database:Server:Ready', function(db)
    if db ~= nil and Core.Modules.Database == nil then
        Core.Internal:DatabaseReady(db)
        return
    end
    Core.Modules.Logger:Error('Database', 'Database Failed to Connect')
    Wait(1000)
    os.exit()
end)

RegisterServerEvent('Core:Server:SessionStarted')
AddEventHandler('Core:Server:SessionStarted', function()
    local src = source
    for _, id in ipairs(GetPlayerIdentifiers(src)) do   
        if string.sub(id, 1, string.len("steam:")) == "steam:" then
            local license = string.sub(id, string.len("steam:") + 1)
            local pos, ply = Core.Modules.Queue:GetFromQueue(license)
            if ply ~= nil then
                ply.State = Core.Queue.States.JOINED
                Core.Players[src] = Core.Modules.Players:CreatePlayer(src, ply.User)
                if Core.Players[src] ~= nil then
                    ply.Source = tonumber(src)
                    Core.Modules.Queue.Session:AddToSession(ply)
                    Core.Modules.Queue:RemoveFromQueue(pos)
                    TriggerEvent('Core:Server:PlayerLoaded', src, Core.Players[src]:Get())
                    TriggerClientEvent('Core:Client:PlayerLoaded', src, Core.Players[src]:Get())
                    Core.Modules.Logger:Info('Queue', ply.User.Name..' has successfully joined the server', {console=true, discord={channel="queue"}})
                end
            end
            return
        end
    end
end)

if GetConvar('ServerMode', 'Live') == "Development" then
    RegisterCommand('loadself', function(src, args, r)
        while not Core.Modules.Proxy.QueueOpen do
            Wait(500)
        end
        local _src = (args[1] and tonumber(args[1]) or src)
        for _, id in ipairs(GetPlayerIdentifiers(src)) do   
            if string.sub(id, 1, string.len("steam:")) == "steam:" then
                local license = string.sub(id, string.len("steam:") + 1)
                Core.Modules.Database.Auth:find({
                    collection = 'Users',
                    query = {
                        Steam = license
                    }
                }, function(suc, res)
                    if not suc then return end
                    if res and res[1] then
                        res[1].SID = res[1]._id
                        res[1]._id = nil
                        Core.Players[_src] = Core.Modules.Players:CreatePlayer(_src, res[1])
                        if Core.Players[_src] ~= nil then
                            TriggerEvent('Core:Server:PlayerLoaded', _src, Core.Players[_src]:Get())
                            TriggerClientEvent('Core:Client:PlayerLoaded', _src, Core.Players[_src]:Get())
                            Core.Modules.Logger:Info('Connected', res[1].Name..' has been successfully manually loaded', {console=true, discord={channel="queue"}})
                            return
                        end
                    end
                    Core.Modules.Logger:Error('Connected', 'There was a problem loading user profile for ServerID '..src, {console=true, discord={channel="queue"}})
                    DropPlayer(src, 'Your User Profile Could not be Loaded, Please Reconnect to the Server.')
                end)
            end
        end
    end)
end