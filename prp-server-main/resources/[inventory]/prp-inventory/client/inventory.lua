secondInventory = nil

RegisterNUICallback('MoveToEmpty', function(data, cb)
    TriggerServerEvent('prp-inventory:MoveToEmpty', data)
    TriggerEvent('prp-inventory:MoveToEmpty', data)
    cb('OK')
end)

RegisterNUICallback('EmptySplitStack', function(data, cb)
    TriggerServerEvent('prp-inventory:EmptySplitStack', data)
    TriggerEvent('prp-inventory:EmptySplitStack', data)
    cb('OK')
end)

RegisterNUICallback('SplitStack', function(data, cb)
    TriggerServerEvent('prp-inventory:SplitStack', data)
    TriggerEvent('prp-inventory:SplitStack', data)
    cb('OK')
end)

RegisterNUICallback('CombineStack', function(data, cb)
    TriggerServerEvent('prp-inventory:CombineStack', data)
    TriggerEvent('prp-inventory:CombineStack', data)
    cb('OK')
end)

RegisterNUICallback('TopoffStack', function(data, cb)
    TriggerServerEvent('prp-inventory:TopoffStack', data)
    TriggerEvent('prp-inventory:TopoffStack', data)
    cb('OK')
end)

RegisterNUICallback('SwapItems', function(data, cb)
    TriggerServerEvent('prp-inventory:SwapItems', data)
    TriggerEvent('prp-inventory:SwapItems', data)
    cb('OK')
end)

RegisterNUICallback('GiveItem', function(data, cb)
    TriggerServerEvent('prp-inventory:GiveItem', data)
    cb('OK')
end)

RegisterNUICallback('GiveCash', function(data, cb)
    TriggerServerEvent('prp-inventory:GiveCash', data)
    cb('OK')
end)

RegisterNUICallback('GetNearPlayers', function(data, cb)

    if data.action == 'give' then
        SendNUIMessage({
            action = "nearPlayersGive",
            players = GetNeareastPlayers(),
            originItem = data.originItem
        })
    end
    if data.action == 'pay' then
        SendNUIMessage({
            action = "nearPlayersPay",
            players = GetNeareastPlayers(),
            originItem = data.originItem
        })
    end
    cb('OK')
end)

function GetNeareastPlayers()
    local playerPed = PlayerPedId()
    local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 2.0)

    local players_clean = {}
    local found_players = false

    for i = 1, #players, 1 do
        if players[i] ~= PlayerId() then
            found_players = true
            table.insert(players_clean, { name = GetPlayerName(players[i]), id = GetPlayerServerId(players[i]) })
        end
    end
    return players_clean
end

RegisterNetEvent('prp-inventory:refreshInventory')
AddEventHandler('prp-inventory:refreshInventory', function()
    Citizen.Wait(100)
    refreshPlayerInventory()
    if secondInventory ~= nil then
        refreshSecondaryInventory()
    end
    SendNUIMessage({
        action = "unlock"
    })
end)

function refreshPlayerInventory()
    TriggerServerEvent('prp-inventory:getPlayerInventory', 'player', GetPlayerServerId(PlayerId()))
end

RegisterNetEvent('prp-inventory:givePlayerInventory')
AddEventHandler('prp-inventory:givePlayerInventory', function(data, id, identifier)
    SendNUIMessage({ action = "setItems",itemList = data.inventory, invOwner = data.invId, invOwnerId = id, invTier = data.invTier, })
    TriggerServerEvent('prp-inventory:openInventory', {
        type = 'player',
        owner = identifier
    })
end)

RegisterNetEvent('prp-inventory:giveClientSecondary')
AddEventHandler('prp-inventory:giveClientSecondary', function(data, secondInventory)
    SendNUIMessage( {
        action = "setSecondInventoryItems",
        itemList = data.inventory,
        invOwner = data.invId,
        invTier = data.invTier,
    })
    Wait(100)
    SendNUIMessage({
        action = "show",
        type = "secondary"
    })

    TriggerServerEvent('prp-inventory:openInventory', secondInventory)
end)

RegisterNetEvent('prp-inventory:denySecondaryInventory')
AddEventHandler('prp-inventory:denySecondaryInventory', function()
    SendNUIMessage({ action = "hide", type = "secondary" })
end)

function refreshSecondaryInventory()
    TriggerServerEvent('prp-inventory:openSecondInventory', secondInventory.type, secondInventory.owner, secondInventory)
end

function closeInventory()
    TriggerEvent('randPickupAnim')
    isInInventory = false
    SendNUIMessage({ action = "hide", type = 'primary'})
    SetNuiFocus(false, false)
    TriggerServerEvent('prp-inventory:closeInventory', {
        type = 'player',
        owner = ESX.GetPlayerData().identifier
    })
    if secondInventory ~= nil then
        TriggerServerEvent('prp-inventory:closeInventory', secondInventory)
    end
    TriggerServerEvent('prp-inventory:checkWeight')
end

RegisterNetEvent('prp-inventory:overweight')
AddEventHandler('prp-inventory:overweight', function(amount)
    if amount >= 250 then
        exports['mythic_notify']:DoHudText('inform', 'Your inventory is above 250 weight! Get rid of items to move!', 5000)
        FreezeEntityPosition(PlayerPedId(), true)
    else
        FreezeEntityPosition(PlayerPedId(), false)
    end
end)

RegisterNetEvent('prp-inventory:openInventory')
AddEventHandler('prp-inventory:openInventory', function(sI)
    openInventory(sI)
end)

function openInventory(_secondInventory)
    isInInventory = true
    --SetTimecycleModifier('hud_def_blur')
    TriggerEvent('randPickupAnim')
    refreshPlayerInventory()
    SendNUIMessage({
        action = "display",
        type = "normal"
    })

    if _secondInventory ~= nil then
        secondInventory = _secondInventory
        refreshSecondaryInventory()
        SendNUIMessage({
            action = "display",
            type = 'secondary'
        })
        if _secondInventory.seize then
            SendNUIMessage({
                action = "showSeize"
            })
        end
        if _secondInventory.steal then
            SendNUIMessage({
                action = "showSteal"
            })
        end
        if _secondInventory["type"] == 'craft' then
            SendNUIMessage({
                action = "showCraft"
            })
        end
    end
    SetNuiFocus(true, true)
end

RegisterNetEvent("prp-inventory:MoveToEmpty")
AddEventHandler("prp-inventory:MoveToEmpty", function(data)
    playPickupOrDropAnimation(data)
    playStealOrSearchAnimation(data)
end)

RegisterNetEvent("prp-inventory:EmptySplitStack")
AddEventHandler("prp-inventory:EmptySplitStack", function(data)
    playPickupOrDropAnimation(data)
    playStealOrSearchAnimation(data)
end)

RegisterNetEvent("prp-inventory:TopoffStack")
AddEventHandler("prp-inventory:TopoffStack", function(data)
    playPickupOrDropAnimation(data)
    playStealOrSearchAnimation(data)
end)

RegisterNetEvent("prp-inventory:SplitStack")
AddEventHandler("prp-inventory:SplitStack", function(data)
    playPickupOrDropAnimation(data)
    playStealOrSearchAnimation(data)
end)

RegisterNetEvent("prp-inventory:CombineStack")
AddEventHandler("prp-inventory:CombineStack", function(data)
    playPickupOrDropAnimation(data)
    playStealOrSearchAnimation(data)
end)

RegisterNetEvent("prp-inventory:SwapItems")
AddEventHandler("prp-inventory:SwapItems", function(data)
    playPickupOrDropAnimation(data)
    playStealOrSearchAnimation(data)
end)

function playPickupOrDropAnimation(data)
    if data.originTier.name == 'drop' or data.destinationTier.name == 'drop' then
        local playerPed = GetPlayerPed(-1)
        if not IsEntityPlayingAnim(playerPed, 'random@domestic', 'pickup_low', 3) then
            ESX.Streaming.RequestAnimDict('random@domestic', function()
                TaskPlayAnim(playerPed, 'random@domestic', 'pickup_low', 8.0, -8, -1, 48, 0, 0, 0, 0)
            end)
        end
    end
end

function playStealOrSearchAnimation(data)
    if data.originTier.name == 'player' and data.destinationTier.name == 'player' then
        local playerPed = GetPlayerPed(-1)
        if not IsEntityPlayingAnim(playerPed, 'random@mugging4', 'agitated_loop_a', 3) then
            ESX.Streaming.RequestAnimDict('random@mugging4', function()
                --TaskPlayAnim(playerPed, 'random@mugging4', 'agitated_loop_a', 8.0, -8, -1, 48, 0, 0, 0, 0)
            end)
        end
    end
end

