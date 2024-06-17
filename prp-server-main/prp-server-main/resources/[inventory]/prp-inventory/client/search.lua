local secondarySearchInventory = {
    type = 'player',
    owner = '',
    seize = true
}

local secondaryStealInventory = {
    type = 'player',
    owner = '',
    steal = true
}

RegisterNetEvent('prp-inventory:search')
AddEventHandler('prp-inventory:search', function()
    local player = ESX.GetPlayerData()
    if player.job.name == 'police' then
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer ~= -1 and closestDistance <= 3.0 then
            RequestAnimDict("random@shop_robbery")
            while not HasAnimDictLoaded("random@shop_robbery") do
                Citizen.Wait(0)
            end
            local searchPlayerPed = GetPlayerPed(closestPlayer)
            --if IsEntityPlayingAnim(searchPlayerPed, 'mp_arresting', 'idle', 3) or IsEntityDead(searchPlayerPed) or GetEntityHealth(searchPlayerPed) <= 0 then
                local lPed = PlayerPedId()
                ClearPedTasksImmediately(lPed)
                TaskPlayAnim(lPed, "random@shop_robbery", "robbery_action_b", 8.0, -8, -1, 16, 0, 0, 0, 0)
                exports['progressBars']:startUI(3500, 'Searching Person')
                Wait(3500)
                ESX.TriggerServerCallback('prp-inventory:getIdentifier', function(identifier)
                    secondarySearchInventory.owner = identifier
                    openInventory(secondarySearchInventory)
                TriggerServerEvent('prp-inventory:SearchLog', true, GetPlayerServerId(closestPlayer), identifier)
                end, GetPlayerServerId(closestPlayer))

                ESX.TriggerServerCallback('esx:getOtherPlayerData', function(data)
                    TriggerEvent('chat:addMessage', {template = '<div class="chat-message state"><b> {0}</b> {1}</div>', args = { "CASH: ",  data.money } })
                    for k,v in pairs(data.accounts) do
                        if v.name == 'black_money' then
                            TriggerEvent('chat:addMessage', {template = '<div class="chat-message state"><b> {0}</b> {1}</div>', args = { "DIRTY: ",  v.money } })
                            break
                        end
                    end
                end, GetPlayerServerId(closestPlayer))
            --end
        end
    end
end)

RegisterNetEvent('prp-inventory:steal')
AddEventHandler('prp-inventory:steal', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        RequestAnimDict("random@shop_robbery")
		while not HasAnimDictLoaded("random@shop_robbery") do
			Citizen.Wait(0)
		end
        local searchPlayerPed = GetPlayerPed(closestPlayer)
        local searchPlayerPed2 = GetPlayerPed(-1)
        if IsEntityPlayingAnim(searchPlayerPed, 'random@mugging3', 'handsup_standing_base', 3) or IsEntityPlayingAnim(searchPlayerPed, 'dead', 'dead_a', 3) and not IsEntityPlayingAnim(searchPlayerPed2, 'dead', 'dead_a', 3)  then
            local lPed = PlayerPedId()
            ClearPedTasksImmediately(lPed)
            TaskPlayAnim(lPed, "random@shop_robbery", "robbery_action_b", 8.0, -8, -1, 16, 0, 0, 0, 0)
            exports['progressBars']:startUI(3500, 'Searching Person')
            Wait(3500)
            ESX.TriggerServerCallback('prp-inventory:getIdentifier', function(identifier)
                secondaryStealInventory.owner = identifier
                openInventory(secondaryStealInventory)
                TriggerServerEvent('prp-inventory:SearchLog', false, GetPlayerServerId(closestPlayer), identifier)
            end, GetPlayerServerId(closestPlayer))

            ESX.TriggerServerCallback('esx:getOtherPlayerData', function(data)
                TriggerEvent('chat:addMessage', {template = '<div class="chat-message state"><b> {0}</b> {1}</div>', args = { "CASH: ",  data.money } })
                for k,v in pairs(data.accounts) do
                    if v.name == 'black_money' then
                        TriggerEvent('chat:addMessage', {template = '<div class="chat-message state"><b> {0}</b> {1}</div>', args = { "DIRTY: ",  v.money } })
                        break
                    end
                end
            end, GetPlayerServerId(closestPlayer))
        end
    end
end)

RegisterNUICallback('StealCash', function(data)
    TriggerServerEvent('prp-inventory:StealCash', data)
end)

RegisterNUICallback('SeizeCash', function(data)
    TriggerServerEvent('prp-inventory:SeizeCash', data)
end)