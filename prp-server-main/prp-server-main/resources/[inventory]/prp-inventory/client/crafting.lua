local craftSecondaryInventory = {
    type = 'craft',
    owner = ''
}

Citizen.CreateThread(function()
    while not ESXLoaded do
        Wait(100)
    end
    for k,v in pairs(Config.Craft) do
        local marker = {
            name = k,
            type = v.markerType or 1,
            coords = v.coords,
            colour = v.markerColour or { r = 55, b = 255, g = 55 },
            size = v.size or vector3(0.5, 0.5, 1.0),
            action = function()
                craftSecondaryInventory.owner = k
                openInventory(craftSecondaryInventory)
                TriggerEvent('prp-inventory:removeCurrentWeapon')
            end,
            shouldDraw = function()
                if v.grade ~= nil then
                    if ESX.PlayerData.job.grade < v.grade then
                        return false
                    end
                end
                return ESX.PlayerData.job.name == v.job or v.job == 'all'
            end,
            msg = v.msg or 'Press ~INPUT_CONTEXT~ to open Craft',
            show3D = true
        }
        TriggerEvent('np_marker:registerMarker', marker)
    end
end)


RegisterNUICallback('Craft', function(data)
    TriggerServerEvent('erp-inventory:craft', data)
end)

local craftTimer = {
    first = 5 * 1000,
    second = 7 * 1000,

    total = 5*1000 + 7*1000
}

-- Crafting pretty much turn into recycling or it's crafting but mainly focusing on smelting items into other others
-- Maybe add timer like idea in pawnshop where amount of items = longer time

-- add table to erp-inventory:craftSuccess so you know what spot and items are being processed on client side
RegisterNetEvent('erp-inventory:craftSuccess')
AddEventHandler('erp-inventory:craftSuccess', function()
    local playerPed = PlayerPedId()
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_HAMMERING", 0, true)

    Citizen.CreateThread(function()
        exports['progressBars']:startUI(craftTimer.total, 'Smelting Items')

        Citizen.Wait(craftTimer.first)
        TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
        Citizen.Wait(craftTimer.second)
        ClearPedTasksImmediately(playerPed)

        TriggerEvent("disc-inventoryhud:ForceDisable", false)
    end)
end)