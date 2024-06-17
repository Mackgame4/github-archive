RegisterNetEvent('_core:Client:Fleet:SelectVehicle', function()
    ESX.TriggerServerCallback("_core:Client:Fleet:GetVehicles", function(vehicles)
        local menuData = {}
        for k, v in pairs(vehicles) do
            table.insert(menuData, { text = ('%s - %s'):format(v.label, v.plate), icon = 'car', type = 'default', action = "SelectVehicle", value = v.plate })
        end
        TriggerEvent('_menu:handleMenu', 'show', 'menu', "Garage", "Select an Available Vehicle", menuData)
    end)
end)

RegisterNetEvent('_core:Client:Fleet:OpenFleetManage', function()
    local menuData = {
        { text = 'Buy Vehicle', icon = 'currency-usd', type = 'default', action = "StartBuyVehicle" },
        { text = 'Sell Vehicle', icon = 'currency-usd', type = 'default', action = "StartSellVehicle" },
    }
    TriggerEvent('_menu:handleMenu', 'show', 'menu', "Garage", "Manage your Fleet", menuData)
end)

RegisterNetEvent('_menu:handleEvent:SelectVehicle', function(plate)
    TriggerServerEvent('_core:Client:Fleet:SelectVehicle', plate)
    TriggerEvent('_menu:handleMenu', 'hide', 'menu')
end)

RegisterNetEvent('_menu:handleEvent:StartSellVehicle', function()
    ESX.TriggerServerCallback("_core:Client:Fleet:GetVehicles", function(vehicles)
        local menuData = {}
        for k, v in pairs(vehicles) do
            table.insert(menuData, { text = ('%s - %s'):format(v.label, v.plate), icon = 'car', type = 'default', action = "SellVehicle", value = v.plate })
        end
        TriggerEvent('_menu:handleMenu', 'show', 'menu', "Garage", "Sell A Vehicle", menuData)
    end)
end)

RegisterNetEvent('_menu:handleEvent:StartBuyVehicle', function()
    ESX.TriggerServerCallback("_core:Client:Fleet:GetAvailableVehicles", function(vehicles)
        local menuData = {}
        for k, v in pairs(vehicles) do
            table.insert(menuData, { text = ('%s - $%s'):format(v.label, v.price), icon = 'car', type = 'default', action = "BuyVehicle", value = v.model })
        end
        TriggerEvent('_menu:handleMenu', 'show', 'menu', "Garage", "Buy A Vehicle", menuData)
    end)
end)

RegisterNetEvent('_menu:handleEvent:BuyVehicle', function(model)
    TriggerServerEvent('_core:Client:Fleet:BuyVehicle', model)
    TriggerEvent('_core:Client:Fleet:OpenFleetManage')
end)

RegisterNetEvent('_menu:handleEvent:SellVehicle', function(plate)
    TriggerServerEvent('_core:Client:Fleet:SellVehicle', plate)
    TriggerEvent('_core:Client:Fleet:OpenFleetManage')
end)

RegisterCommand('testspawn', function()
    TriggerEvent('_core:Client:Fleet:TakeOutVehicle')
end)

RegisterNetEvent('_core:Client:Fleet:TakeOutVehicle', function()
    ESX.TriggerServerCallback('_core:Server:Fleet:TakeOutVehicle', function(data)
        print(json.encode(data))
        if not data then
            return
        end

        for k, v in ipairs(data.spawns or {}) do
            print(ESX.Game.IsSpawnPointClear(v.location, 3.0))
            if ESX.Game.IsSpawnPointClear(v.location, 3.0) then
                print(data.model)
                ESX.Game.SpawnVehicle(data.model, v.location, v.heading, function(vehicle)
                    SetVehicleNumberPlateText(vehicle, data.plate)
                end, true)
                return
            end
        end
    end)
end)
