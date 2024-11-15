local freeCam = true
local usingBennys = false
local actualvehicle = nil
local MenuMods = {}
local vehicleList = exports['ui-vehicleshop']:getServerVehicles()

-- Create Blips
Citizen.CreateThread(function()
	for k,v in ipairs(Config.Bennys) do
		local center = { x = 0, y = 0 }
		local points = 0
		for k1, v1 in ipairs(v.points) do
			center.x = center.x + v1.x
			center.y = center.y + v1.y
			points = points + 1
		end
		local blip = AddBlipForCoord(center.x/points, center.y/points)
		--local blip = AddBlipForCoord(v.blip)
		SetBlipSprite(blip, 446)
		SetBlipColour(blip, 17)
		SetBlipScale(blip, 0.8)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(v.name)
		EndTextCommandSetBlipName(blip)

		local bennys = PolyZone:Create(v.points, {
			name="bennys",
			minZ=v.minZ,
			maxZ=v.maxZ,
			debugGrid=false,
			debugPoly=false
		})

		bennys:onPointInOut(PolyZone.getPlayerPosition, function(isPointInside, point)
			if isPointInside then
				TriggerEvent('_drawtextui:ShowUI', 'show', "[ ".. GetControlInstructionalButton(0, 0x8ced1179, 1):gsub("t_", "").." ] ".."Open Benny's")
				enableBennysInteract = true
			else
				TriggerEvent('_drawtextui:HideUI')
				enableBennysInteract = false
			end
		end)
	end
end)

function getVehicleMods(vehicle)
	SetVehicleModKit(vehicle, 0)
	for k,v in pairs(vehicleList) do
		local model = GetEntityModel(vehicle)
		local name = GetDisplayNameFromVehicleModel(model)
		if name:lower() == v.name then
			for k1,v1 in pairs(Config.vehicleModsList) do
				if v1.sale then
					v1.multiplier = 0.1
				end
				if v1.isToggle then
					MenuMods[v1.index] = {
						name = k1,
						index = v1.index,
						label = v1.label,
						description = v1.description,
						icon = v1.icon,
						sale = v1.sale,
						value = v1.multiplier*v.price,
						isToggle = v1.isToggle,
						max = GetNumVehicleMods(vehicle, v1.index)+1
					}
				else
					MenuMods[v1.index] = {
						name = k1,
						index = v1.index,
						label = v1.label,
						description = v1.description,
						icon = v1.icon,
						sale = v1.sale,
						value = v1.multiplier*v.price,
						isToggle = v1.isToggle,
						max = GetNumVehicleMods(vehicle, v1.index)
					}
				end
				-- TODO: Add cart to return to default mod (last mod)
			end
		end
	end
end

function openBennys()
	--print("openBennys")
	local ped = PlayerPedId()
	local InVehicle = IsPedSittingInAnyVehicle(ped)
    actualvehicle = GetVehiclePedIsIn(ped)
	if InVehicle then
		usingBennys = true
		FreezeEntityPosition(actualvehicle, true)
		SetNuiFocus(true, true)
		SetNuiFocusKeepInput(true)
		getVehicleMods(actualvehicle)
		SendNUIMessage({
			action = "show",
			menuMods = MenuMods
		})
		--TriggerEvent('_drawtextui:HideUI')
		--Wait(100)
		TriggerEvent('_drawtextui:ShowUI', 'show', "[ G ] Free Camera")
	else
		usingBennys = false
		TriggerEvent('_drawtextui:ShowNotify', 'error', 2000, "You need to be in a vehicle to use this menu.")
		Wait(2000)
		TriggerEvent('_drawtextui:ShowUI', 'show', "[ ".. GetControlInstructionalButton(0, 0x8ced1179, 1):gsub("t_", "").." ] ".."Open Benny's")
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if usingBennys and freeCam then
			DisableControlAction(0, 1, true) -- LookLeftRight
            DisableControlAction(0, 2, true) -- LookUpDown
            DisableControlAction(0, 142, true) -- MeleeAttackAlternate
            DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
			DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 85, true)
			DisableControlAction(0, 16, true)
			DisableControlAction(0, 17, true)
			DisableControlAction(0, 99, true)
			DisableControlAction(0, 100, true)
			DisableControlAction(0, 115, true)
			DisableControlAction(0, 116, true)
			DisableControlAction(0, 261, true)
			DisableControlAction(0, 262, true)
			DisableInputGroup(24)
			--HideHudComponentThisFrame(16)
			--HideHudComponentThisFrame(19)
			--DisableControlAction(2, 199, true) -- Disable pause screen
			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		end
	end
end)

RegisterNUICallback('applyMod', function(data, cb)
	print("Applied mod", data.item.installed, "of", GetNumVehicleMods(actualvehicle, data.item.index), "with isToggle", data.item.isToggle)
	--print("applyMod", data.item, data.item.name, data.item.label, data.item.index, data.item.installed)
	local colorPrimary, colorSecondary = GetVehicleColours(actualvehicle)
	local pearlescentColor, wheelColor = GetVehicleExtraColours(actualvehicle)

	if data.item.name == 'plate' then SetVehicleNumberPlateText(vehicle, data.item.installed) end
	if data.item.name == 'plateIndex' then SetVehicleNumberPlateTextIndex(vehicle, data.item.installed) end
	--[[if props.bodyHealth then SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0) end
	if props.engineHealth then SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0) end
	if props.tankHealth then SetVehiclePetrolTankHealth(vehicle, props.tankHealth + 0.0) end
	if props.fuelLevel then SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0) end
	if props.dirtLevel then SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0) end
	if props.color1 then SetVehicleColours(vehicle, props.color1, colorSecondary) end
	if props.color2 then SetVehicleColours(vehicle, props.color1 or colorPrimary, props.color2) end
	if props.pearlescentColor then SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor) end
	if data.item.name == 'wheelColor' then SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor) end
	if data.item.name == 'wheels' then SetVehicleWheelType(vehicle, props.wheels) end
	if data.item.name == 'windowTint' then SetVehicleWindowTint(vehicle, props.windowTint) end
	if props.neonEnabled then
		SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
		SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
		SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
		SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
	end
	if props.extras then
		for extraId,enabled in pairs(props.extras) do
			if enabled then
				SetVehicleExtra(vehicle, tonumber(extraId), 0)
			else
				SetVehicleExtra(vehicle, tonumber(extraId), 1)
			end
		end
	end
	if props.neonColor then SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3]) end
	if props.xenonColor then SetVehicleXenonLightsColour(vehicle, props.xenonColor) end
	if props.modSmokeEnabled then ToggleVehicleMod(vehicle, 20, true) end
	if props.tyreSmokeColor then SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3]) end
	if props.modSpoilers then SetVehicleMod(vehicle, 0, props.modSpoilers, false) end
	if props.modFrontBumper then SetVehicleMod(vehicle, 1, props.modFrontBumper, false) end
	if props.modRearBumper then SetVehicleMod(vehicle, 2, props.modRearBumper, false) end
	if props.modSideSkirt then SetVehicleMod(vehicle, 3, props.modSideSkirt, false) end
	if props.modExhaust then SetVehicleMod(vehicle, 4, props.modExhaust, false) end
	if props.modFrame then SetVehicleMod(vehicle, 5, props.modFrame, false) end
	if props.modGrille then SetVehicleMod(vehicle, 6, props.modGrille, false) end
	if props.modHood then SetVehicleMod(vehicle, 7, props.modHood, false) end
	if props.modFender then SetVehicleMod(vehicle, 8, props.modFender, false) end
	if props.modRightFender then SetVehicleMod(vehicle, 9, props.modRightFender, false) end
	if props.modRoof then SetVehicleMod(vehicle, 10, props.modRoof, false) end
	if props.modEngine then SetVehicleMod(vehicle, 11, props.modEngine, false) end
	if props.modBrakes then SetVehicleMod(vehicle, 12, props.modBrakes, false) end
	if props.modTransmission then SetVehicleMod(vehicle, 13, props.modTransmission, false) end
	if props.modHorns then SetVehicleMod(vehicle, 14, props.modHorns, false) end
	if props.modSuspension then SetVehicleMod(vehicle, 15, props.modSuspension, false) end
	if props.modArmor then SetVehicleMod(vehicle, 16, props.modArmor, false) end
	if props.modTurbo then ToggleVehicleMod(vehicle,  18, props.modTurbo) end
	if props.modXenon then ToggleVehicleMod(vehicle,  22, props.modXenon) end
	if props.modFrontWheels then SetVehicleMod(vehicle, 23, props.modFrontWheels, false) end
	if props.modBackWheels then SetVehicleMod(vehicle, 24, props.modBackWheels, false) end
	if props.modPlateHolder then SetVehicleMod(vehicle, 25, props.modPlateHolder, false) end
	if props.modVanityPlate then SetVehicleMod(vehicle, 26, props.modVanityPlate, false) end
	if props.modTrimA then SetVehicleMod(vehicle, 27, props.modTrimA, false) end
	if props.modOrnaments then SetVehicleMod(vehicle, 28, props.modOrnaments, false) end
	if props.modDashboard then SetVehicleMod(vehicle, 29, props.modDashboard, false) end
	if props.modDial then SetVehicleMod(vehicle, 30, props.modDial, false) end
	if props.modDoorSpeaker then SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false) end
	if props.modSeats then SetVehicleMod(vehicle, 32, props.modSeats, false) end
	if props.modSteeringWheel then SetVehicleMod(vehicle, 33, props.modSteeringWheel, false) end
	if props.modShifterLeavers then SetVehicleMod(vehicle, 34, props.modShifterLeavers, false) end
	if props.modAPlate then SetVehicleMod(vehicle, 35, props.modAPlate, false) end
	if props.modSpeakers then SetVehicleMod(vehicle, 36, props.modSpeakers, false) end
	if props.modTrunk then SetVehicleMod(vehicle, 37, props.modTrunk, false) end
	if props.modHydrolic then SetVehicleMod(vehicle, 38, props.modHydrolic, false) end
	if props.modEngineBlock then SetVehicleMod(vehicle, 39, props.modEngineBlock, false) end
	if props.modAirFilter then SetVehicleMod(vehicle, 40, props.modAirFilter, false) end
	if props.modStruts then SetVehicleMod(vehicle, 41, props.modStruts, false) end
	if props.modArchCover then SetVehicleMod(vehicle, 42, props.modArchCover, false) end
	if props.modAerials then SetVehicleMod(vehicle, 43, props.modAerials, false) end
	if props.modTrimB then SetVehicleMod(vehicle, 44, props.modTrimB, false) end
	if props.modTank then SetVehicleMod(vehicle, 45, props.modTank, false) end
	if props.modWindows then SetVehicleMod(vehicle, 46, props.modWindows, false) end
	if props.modLivery then
		SetVehicleMod(vehicle, 48, props.modLivery, false)
		SetVehicleLivery(vehicle, props.modLivery)
	end]]--
	SetVehicleMod(actualvehicle, data.item.index, data.item.installed)
	if data.item.isToggle then
		if data.item.installed == 0 then
			ToggleVehicleMod(actualvehicle, data.item.index, true)
		else
			ToggleVehicleMod(actualvehicle, data.item.index, false)
		end
	end
	--[[ESX.Game.SetVehicleProperties(actualvehicle, {
        plate = 'ESX',
        modTurbo = true
    })]]--
	--local vehProps = ESX.Game.GetVehicleProperties(actualvehicle)
	--print(ESX.DumpTable(vehProps))
	--TriggerServerEvent('esx-bennys:setVehicleProps', vehProps)
	--cb('ok')
end)

local doorStatus = {}
RegisterNUICallback('toggleDoors', function(data, cb)
	local vehicleDoors = GetNumberOfVehicleDoors(actualvehicle)
	for door = 0, vehicleDoors + 1, 1 do
		if doorStatus[door] then
			SetVehicleDoorShut(actualvehicle, door, false)
			doorStatus[door] = false
		else
			SetVehicleDoorOpen(actualvehicle, door, false, false)
			doorStatus[door] = true
		end
	end
	--cb('ok')
end)

RegisterNUICallback('close', function(data, cb)
	usingBennys = false
	SetNuiFocus(false, false)
	TriggerEvent('_drawtextui:ShowUI', 'show', "[ ".. GetControlInstructionalButton(0, 0x8ced1179, 1):gsub("t_", "").." ] ".."Open Benny's")
	if actualvehicle then
		FreezeEntityPosition(actualvehicle, false)
	end
	--cb('ok')
end)

AddEventHandler('OnInteract', function(action, text)
	if enableBennysInteract then
		openBennys()
	end
end)

AddEventHandler('OnSecondaryInteract', function(action, text)
	if enableBennysInteract and usingBennys then
		if freeCam then
			freeCam = false
			SetNuiFocus(false, false)
			TriggerEvent('_drawtextui:ShowUI', 'show', "[ G ] Lock Camera")
		elseif not freeCam then
			freeCam = true
			SetNuiFocus(true, true)
			TriggerEvent('_drawtextui:ShowUI', 'show', "[ G ] Free Camera")
		end
	end
end)