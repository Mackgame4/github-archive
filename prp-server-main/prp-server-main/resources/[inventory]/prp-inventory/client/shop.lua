esx = nil

Citizen.CreateThread(function()
	while esx == nil do
		TriggerEvent('esx:getSharedObject', function(obj) esx = obj end)
		Citizen.Wait(500)
	end
end)

local shopSecondaryInventory = {
    type = 'shop',
    owner = ''
}

Citizen.CreateThread(function()
    while not ESXLoaded do
        Citizen.Wait(50)
    end
    for k, v in pairs(Config.Shops) do
        if v.Blip ~= nil then
            for i = 1, #v.coords, 1 do
                local blip = AddBlipForCoord(v.coords[i].x, v.coords[i].y, v.coords[i].z)
                SetBlipSprite (blip, v.Blip.Id)
                SetBlipDisplay(blip, 4)
                SetBlipScale  (blip, 0.8)
                SetBlipColour (blip, v.Blip.Color)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(v.Blip.Text)
                EndTextCommandSetBlipName(blip)
            end
        end
        for val, coords in pairs(v.coords) do
            local marker = {
                name = k .. val,
                coords = coords,
                type = v.markerType or 1,
                colour = v.markerColour or { r = 55, b = 255, g = 55 },
                size = v.size or vector3(1.5, 1.5, 1.5),
                action = function()
                    shopSecondaryInventory.owner = k
                    openInventory(shopSecondaryInventory)
                end,
                shouldDraw = function()
                    if v.job == 'mechanics' then
                        return ESX.PlayerData.job.name == '3nv7james' or ESX.PlayerData.job.name == '3nv7castro' or ESX.PlayerData.job.name == 'luxuryautos' or ESX.PlayerData.job.name == 'jt3nv7' or ESX.PlayerData.job.name == 'pdm' or ESX.PlayerData.job.name == 'lostmc'
                    end
                    return ESX.PlayerData.job.name == v.job or v.job == 'all'
                end,
				msg = v.msg or "Press ~INPUT_CONTEXT~ to open Shop",
				show3D = true
            }
            TriggerEvent('np_marker:registerMarker', marker)
        end
    end
end)

local gunshopSecondaryInventory = {
    type = 'gunshop',
    owner = ''
}

Citizen.CreateThread(function()
    while not ESXLoaded do
        Citizen.Wait(50)
    end
    for k, v in pairs(Config.gunshop) do
        if v.Blip ~= nil then
            for i = 1, #v.coords, 1 do
                local blip = AddBlipForCoord(v.coords[i].x, v.coords[i].y, v.coords[i].z)
                SetBlipSprite (blip, v.Blip.Id)
                SetBlipDisplay(blip, 4)
                SetBlipScale  (blip, 0.8)
                SetBlipColour (blip, v.Blip.Color)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(v.Blip.Text)
                EndTextCommandSetBlipName(blip)
            end
        end
        for val, coords in pairs(v.coords) do
            local marker = {
                name = k .. val,
                coords = coords,
                type = v.markerType or 1,
                colour = v.markerColour or { r = 55, b = 255, g = 55 },
                size = v.size or vector3(1.5, 1.5, 1.5),
                action = function()
                    esx.TriggerServerCallback('CityLife:License:checkLicense', function(hasWeaponLicense)
                        if hasWeaponLicense then
                            gunshopSecondaryInventory.owner = k
                            openInventory(gunshopSecondaryInventory)
                        else
                            show3D = true
                            -- exports['mythic_notify']:DoHudText('error', "You don't own a weapon license, head to the Weapon License Test")
                            exports['mythic_notify']:DoHudText('error', "You don't own a weapon license, you must get one from a judge")
                        end
                    end, GetPlayerServerId(PlayerId()), 'weapon')   
                end, 
                shouldDraw = function()
                    if v.job == 'mechanics' then
                        return ESX.PlayerData.job.name == '3nv7james' or ESX.PlayerData.job.name == '3nv7castro' or ESX.PlayerData.job.name == 'luxuryautos' or ESX.PlayerData.job.name == 'jt3nv7' or ESX.PlayerData.job.name == 'pdm' or ESX.PlayerData.job.name == 'lostmc'
                    end
                    return ESX.PlayerData.job.name == v.job or v.job == 'all'
                end,
				msg = v.msg or "Press ~INPUT_CONTEXT~ to open Shop",
				show3D = true
            }
            TriggerEvent('np_marker:registerMarker', marker)
        end
    end
end)