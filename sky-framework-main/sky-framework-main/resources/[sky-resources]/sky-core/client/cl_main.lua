Core.Internal = Core.Internal or {}

Core.Internal.Init = function(self)
    if Core.Config.Tokenizer.Verbose then
        Core.Modules.Logger:Info('Tokenizer', "> > > D E B U G   M O D E   E N A B L E D  < < <")
    end
    AddEventHandler('Core:Token:Client:ClientReady', function()
        Core.Config.SecurityToken = Core.Modules.Tokenizer:SetupClientResource(GetInvokingResource() or GetCurrentResourceName())
    end)
    Citizen.CreateThread(function()
        math.randomseed(GetClockHours() + GetClockMinutes())
        while not exports or exports[GetCurrentResourceName()] == nil do
            Citizen.Wait(1)
        end
        TriggerEvent('Core:Token:Client:ClientReady')
        Citizen.Wait(Core.Config.Tokenizer.ClientDelay)
        TriggerServerEvent('Core:Token:Server:PlayerSpawned')
        while Core.Config.SecurityToken == nil do Wait(1) end
        Core.Modules.Functions:SetGame()
        Core.Modules.Logger:Info('Core', 'Server Configured for '..Core.Modules.Proxy.ServerMeta.GameName)
        self:StartLoops()
        TriggerEvent('Proxy:Shared:RegisterReady')
        for k, v in pairs(Core.Modules) do TriggerEvent('Proxy:Shared:ExtendReady', k) end
    
        Citizen.Wait(1000)
    
        Core.Modules.Proxy.ExportsReady = true
        TriggerEvent('Core:Shared:Ready')
        Citizen.Wait(1500)
        Core.Modules.Proxy.ScriptsReady = true
        TriggerEvent('Core:Shared:ScriptsReady')
        Core.Modules.Logger:Success('Core', "Client Connected")
        
    end)
end

Core.Internal.StartLoops = function(self)
    Citizen.CreateThread(function()
        if Core.Modules.Functions:IsRDR() then
            -- RedM
            while true do
                local spawned = Citizen.InvokeNative(0xB8DFD30D6973E135, PlayerPedId(), Citizen.ResultAsInteger())
                if spawned then
                    TriggerServerEvent('Core:Server:SessionStarted')
                    TriggerEvent('Core:Client:SessionStarted')
                    break
                end
            end

            return
        else
            -- FiveM
            while true do
                if NetworkIsPlayerActive(PlayerId()) then
                    TriggerEvent('Core:Client:SessionStarted')
                    TriggerServerEvent('Core:Server:SessionStarted')
                    break
                end
                Citizen.Wait(100)
            end

            if Core.Config.Global.FiveM.DisableDispatch then
                for i = 1, 25 do
                    EnableDispatchService(i, false)
                end

                Citizen.CreateThread(function()            
                    while true do        
                        SetMaxWantedLevel(0)
                        SetCreateRandomCopsNotOnScenarios(false)
                        SetCreateRandomCops(false)
                        SetCreateRandomCopsOnScenarios(false)
                        Citizen.Wait(5)
                    end
                end)
            end

            if Core.Config.Global.FiveM.DisableIdleCam then
                Citizen.CreateThread(function() 
                    while true do
                        InvalidateIdleCam()
                        N_0x9e4cfff989258472()
                        Wait(25000)
                    end 
                end)
            end
            return
        end
    end)
end