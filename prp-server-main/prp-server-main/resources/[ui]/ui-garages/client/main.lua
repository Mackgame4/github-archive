local garageName = nil
local vehicles = {}
local vehiclesInGarage = {}

Citizen.CreateThread(function()
	for k,v in ipairs(Config.Garages) do
		local centerBlip = (v.points[1] + v.points[2] + v.points[3] + v.points[4]) / 4
		local centerBlipPos = vector3(centerBlip.x, centerBlip.y, v.minZ)
		local blip = AddBlipForCoord(centerBlipPos)

		SetBlipSprite (blip, 357)
		SetBlipDisplay(blip, 4)
		SetBlipColour(blip, 40)
		SetBlipScale  (blip, 0.8)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Public Garage')
		EndTextCommandSetBlipName(blip)

		local garage = PolyZone:Create(v.points, {
			name=k.."garage",
			minZ=v.minZ,
			maxZ=v.maxZ,
			debugGrid=false,
			debugPoly=false
		})
		
		garage:onPointInOut(PolyZone.getPlayerPosition, function(isPointInside, point)
			if isPointInside then
				TriggerEvent('_drawtextui:ShowUI', 'show', "[ ".. GetControlInstructionalButton(0, 0x8ced1179, 1):gsub("t_", "").." ] ".."Open Garage")
				enableGarageInteract = true
				garageName = v.name
			else
				TriggerEvent('_drawtextui:HideUI')
				enableGarageInteract = false
			end
		end)
	end
end)

AddEventHandler('OnInteract', function(action, text)
	if enableGarageInteract then
		openGarage()
	end
end)

--[[function Load(name)
	local resourceName = GetCurrentResourceName()
	local chunk = LoadResourceFile(resourceName, ('data/%s.lua'):format(name))
	if chunk then
		local err
		chunk, err = load(chunk, ('@@%s/data/%s.lua'):format(resourceName, name), 't')
		if err then
			error(('\n^1 %s'):format(err), 0)
		end
		return chunk()
	end
end]]--

function insertOnVehiclesTable(value)
	for k, v in ipairs(vehicles) do
		if v == value then
			return
		end
	end
	table.insert(vehicles, value)
end

function insertOnGarageVehiclesTable(value)
	for k, v in ipairs(vehiclesInGarage) do
		if v == value then
			return
		end
	end
	table.insert(vehiclesInGarage, value)
end

function openGarage()
	TriggerServerEvent("getPlayerVehicles")
	thisVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	if thisVehicle then
		local thisVehiclePlate = GetVehicleNumberPlateText(thisVehicle) -- TODO: Check if vehicle is from player
		FreezeEntityPosition(thisVehicle, true)
	end
	if thisVehicle ~= 0 then
		isInVehicle = true
	else
		isInVehicle = false
	end
	SetNuiFocus(true, true)
	TriggerEvent('_drawtextui:HideUI')
end

-- TODO: Change ID colors for RGB on vehicleshop
--[[local colors = Load('colors')
print(colors)]]--
RegisterNetEvent("RetrieveVehicles")
AddEventHandler("RetrieveVehicles", function(result)
	local vehicleList = exports['ui-vehicleshop']:getServerVehicles()
	local playerOwnedVehicles = result[1].ownedVehicles
	for k, v in ipairs(playerOwnedVehicles) do
		vehicle = json.decode(v)
		--print(ESX.DumpTable(v), ESX.DumpTable(vehicle), vehicle.label)
		for k1, v1 in ipairs(vehicleList) do
			if vehicle.name == v1.name then
				vehicle.type = v1.type
				vehicle.data = {inGarage = true, handling = 70, topspeed = 100, acceleration = 85, hp = 80, torque = 55, brake = 70, engine = 25, body = 80}
				vehicle.menuColors = {engine = "info darken-3", body = "info darken-3"}
				insertOnVehiclesTable(vehicle)
				for k2, v2 in ipairs(vehicles) do
					--print(v2.name, vehicle.name)
					if v2.name == vehicle.name then
						insertOnGarageVehiclesTable(v2)
					end
				end
			end
		end
	end
	SendNUIMessage({
		action = "show",
		garageName = garageName,
		isInVehicle = isInVehicle,
		vehicles = vehiclesInGarage
	})
end)

RegisterNUICallback('close', function(data, cb)
	vehicles = {}
	vehiclesInGarage = {}
	SetNuiFocus(false, false)
	TriggerEvent('_drawtextui:ShowUI', 'show', "[ ".. GetControlInstructionalButton(0, 0x8ced1179, 1):gsub("t_", "").." ] ".."Open Garage")
	if thisVehicle then
		FreezeEntityPosition(thisVehicle, false)
	end
	--cb('ok')
end)