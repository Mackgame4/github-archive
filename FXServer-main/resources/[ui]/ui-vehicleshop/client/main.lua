local isNearVehicle = false
local nearVehiclePos = nil
local nearVehicle = nil
local nearVehiclePrice = 0
local isOnTestDrive = false
local vPrimaryColor = nil
local vSecondaryColor = nil


RegisterNetEvent("ToggleVehicleLock")
AddEventHandler("ToggleVehicleLock", function(data)
	local vehicle = data.entity
	local model = GetEntityModel(vehicle)
	local name = GetDisplayNameFromVehicleModel(model)
	local label = nil
	for k, v in ipairs(Config.Vehicles) do
		if name:lower() == v.name then
			label = v.label
		end
	end
	-- TODO: Server sync
	if GetVehicleDoorLockStatus(vehicle) ~= 2 then 
		locked = 2
		TriggerEvent('_drawtextui:ShowNotify', 'error', 3500, "You locked your "..label..".")
	elseif GetVehicleDoorLockStatus(vehicle) == 2 then
		locked = 1
		TriggerEvent('_drawtextui:ShowNotify', 'success', 3500, "You unlocked your "..label..".")
	end
	local dict = "anim@mp_player_intmenu@key_fob@"
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(1)
	end
	if not IsPedInAnyVehicle(PlayerPedId(), true) then
		TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
	end
	StartVehicleHorn(vehicle, 1000, "NORMAL", false)
	SetVehicleLights(vehicle, 2)
	Citizen.Wait(150)
	SetVehicleLights(vehicle, 0)
	Citizen.Wait(150)
	SetVehicleLights(vehicle, 2)
	Citizen.Wait(150)
	SetVehicleLights(vehicle, 0)
	SetVehicleDoorsLocked(vehicle, locked)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
end)

Citizen.CreateThread(function()
	for k,v in ipairs(Config.Dealerships) do
		local blip = AddBlipForCoord(v.shopEntering)

		SetBlipSprite (blip, 523)
		SetBlipDisplay(blip, 4)
		SetBlipColour(blip, 1)
		SetBlipScale  (blip, 0.8)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName("Vehicle Shop")
		EndTextCommandSetBlipName(blip)

		--[[local shopEntering = BoxZone:Create(v.shopEntering, 3.0, 5.0, {
			name="shopEntering",
			offset={0.0, 0.0, 0.0},
			scale={1.0, 1.0, 1.0},
			heading=207.3142,
			debugPoly=false
		})

		shopEntering:onPointInOut(PolyZone.getPlayerPosition, function(isPointInside, point)
			if isPointInside then
				TriggerEvent('_drawtextui:ShowUI', 'show', "[ ".. GetControlInstructionalButton(0, 0x8ced1179, 1):gsub("t_", "").." ] ".."Vehicle Shop")
				enableVehicleShopInteract = true
			else
				TriggerEvent('_drawtextui:HideUI')
				enableVehicleShopInteract = false
			end
		end)]]--

		if ESX.Game.IsSpawnPointClear(vector3(v.shopEnteringNPC.x, v.shopEnteringNPC.y, v.shopEnteringNPC.z), 3) then
			local modelHash = GetHashKey("a_m_y_smartcaspat_01")
			RequestModel(modelHash)
			while not HasModelLoaded(modelHash) do
				Wait(1)
			end
			created_ped = CreatePed(1, modelHash , vector3(v.shopEnteringNPC.x, v.shopEnteringNPC.y, v.shopEnteringNPC.z-1), v.shopEnteringNPC.w, false, false)
			SetEntityInvincible(created_ped, true)
			FreezeEntityPosition(created_ped, true)
			SetBlockingOfNonTemporaryEvents(created_ped, true)
			TaskStartScenarioInPlace(created_ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
			exports['ui-interact']:AddTargetModel(modelHash, {
				options = {
					{
						event = "openVehicleshop",
						icon = "mdi-car",
						label = "Open Vehicle Shop",
						enabled = false
					}
				},
				job = {"all"},
				distance = 2.5
			})
		end

		-- TODO: See if cars "despawn" when they're not in the shop
		local vehicleShop = PolyZone:Create(v.points, {
			name="vehicleShop",
			minZ=v.minZ,
			maxZ=v.maxZ,
			debugGrid=false,
			debugPoly=false
		})
		
		vehicleShop:onPointInOut(PolyZone.getPlayerPosition, function(isPointInside, point)
			if isPointInside then
				for k, v in ipairs(Config.Showroom) do
					if ESX.Game.IsSpawnPointClear(v.coords, 3) then
						ESX.Game.SpawnVehicle(v.model, v.coords, v.heading, function(vehicle)
							if Debug then
								ESX.Log("[^5"..GetCurrentResourceName().."^7]", "Spawned "..DoesEntityExist(vehicle), v.model, "at: ".. v.coords.x ..", ".. v.coords.y ..", ".. v.coords.z)
							end
							SetVehicleOnGroundProperly(vehicle)
							SetEntityInvincible(vehicle, true)
							FreezeEntityPosition(vehicle, true)
						end)
					end

					local closestVehicle = BoxZone:Create(v.coords, 5.5, 3.5, {
						name=k.."closestVehicle",
						offset={0.0, 0.0, 0.0},
						scale={1.0, 1.0, 1.0},
						heading=v.heading,
						debugPoly=false
					})
			
					closestVehicle:onPointInOut(PolyZone.getPlayerPosition, function(isPointNear, point)
						if isPointNear then
							isNearVehicle = true
							nearVehiclePos = v.coords
							nearVehicle = v.model
						else
							isNearVehicle = false
							nearVehiclePos = nil
							nearVehicle = nil
						end
					end)
				end
				while true do
					Citizen.Wait(1)
					if isNearVehicle and nearVehiclePos and nearVehicle then
						for k, v in ipairs(Config.Vehicles) do
							if nearVehicle == v.name then
								DrawText3Ds(nearVehiclePos, v.label.."\n~g~$~s~"..v.price.."\nPress [ ~r~E~s~ ] to buy or [ ~b~G~s~ ] to test drive", false)
							end
						end
					end
				end
			end
		end)
	end
end)

function DrawText3Ds(coords, text, drawRect)
	local onScreen,_x,_y=World3dToScreen2d(coords.x, coords.y, coords.z+1.5)
	if onScreen then
		SetTextScale(0.38, 0.38)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
		if drawRect then
			local factor = (string.len(text)) * 0.0025
			DrawRect(_x,_y+0.0125, 0.025+ factor, 0.03, 0, 0, 0, 150)
		end
	end
end

Citizen.CreateThread(function()
	RequestIpl('shr_int') -- Load walls and floor
	local interiorID = 7170
	LoadInterior(interiorID)
	EnableInteriorProp(interiorID, 'csr_beforeMission') -- Load large window
	RefreshInterior(interiorID)
end)

AddEventHandler('OnInteract', function()
	if isNearVehicle then
		for k, v in ipairs(Config.Vehicles) do
			if nearVehicle == v.name then
				SendNUIMessage({
					showMenu = true,
					useStocks = Config.UseStocks,
					vehiclesList = Config.Vehicles,
					customDataset = {
						label = v.label,
						name = v.name,
						price = v.price,
						type = v.type,
						class = v.class,
						stock = v.stock,
					}
				})
			end
		end
		SetNuiFocus(true, true)
	end
end)

AddEventHandler('OnSecondaryInteract', function()
	if isNearVehicle then
		if not isOnTestDrive then
			for k,v in ipairs(Config.Dealerships) do
				if ESX.Game.IsSpawnPointClear(v.testdriveSpawn, 3) then
					-- TODO: test if vehicle is not visible to other players
					ESX.Game.SpawnLocalVehicle(nearVehicle, vector3(v.testdriveSpawn.x, v.testdriveSpawn.y, v.testdriveSpawn.z), v.testdriveSpawn.w, function(testdriveVehicle)
						isOnTestDrive = true
						TaskWarpPedIntoVehicle(GetPlayerPed(-1), testdriveVehicle, -1)
						TriggerEvent('_drawtextui:ShowNotify', 'info', 3500, math.floor(Config.TestDriveTimer / 60).." minutes timer test trive started!")
						TriggerEvent('startTimer', testdriveVehicle, v.shopEntering)
					end)
				else
					TriggerEvent('_drawtextui:ShowNotify', 'error', 2000, "Spawn point isn't clear")
				end
			end
		else
			TriggerEvent('_drawtextui:ShowNotify', 'error', 2500, "Your already on a test drive.")
		end
	end
end)

RegisterNetEvent('startTimer')
AddEventHandler('startTimer', function(testdriveVehicle, spawnPosition)
    local time = Config.TestDriveTimer -- timer seconds
    while (time ~= 0) do -- Whist we have time to wait
        Wait(1000) -- Wait a second
        time = time - 1
        -- 1 Second should have past by now
    end
    -- When the above loop has finished. We can now do something
	isOnTestDrive = false
    TriggerEvent('_drawtextui:ShowNotify', 'info', 3500, "Test drive ended, hope you enjoyed :)")
	ESX.Game.Teleport(GetPlayerPed(-1), spawnPosition)
	DeleteEntity(testdriveVehicle)
end)

RegisterNetEvent("deleteVehicle")
AddEventHandler("deleteVehicle", function(vehicle)
	if vehicle then
		DeleteEntity(vehicle)
		for k, v in ipairs(Config.Dealerships) do
			ESX.Game.Teleport(GetPlayerPed(-1), v.shopEntering)
		end
	end
end)

RegisterNUICallback('handleConfirm', function(data, cb)
	SetNuiFocus(false, false)
	if vPrimaryColor ~= nil and vSecondaryColor ~= nil then
		for k,v in ipairs(Config.Dealerships) do
			if ESX.Game.IsSpawnPointClear(v.testdriveSpawn, 3) then
				local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
				local actualPrimaryColor, actualSecondaryColor = GetVehicleColours(veh)
				DeleteEntity(veh)
				Wait(100)
				ESX.Game.SpawnVehicle(data.selectedVehicle, vector3(v.testdriveSpawn.x, v.testdriveSpawn.y, v.testdriveSpawn.z), v.testdriveSpawn.w, function(boughtVehicle)
					TaskWarpPedIntoVehicle(GetPlayerPed(-1), boughtVehicle, -1)
					Wait(100)
					if vPrimaryColor ~= nil and vSecondaryColor ~= nil then
						SetVehicleCustomPrimaryColour(boughtVehicle, vPrimaryColor[1], vPrimaryColor[2], vPrimaryColor[3])
						SetVehicleCustomSecondaryColour(boughtVehicle, vSecondaryColor[1], vSecondaryColor[2], vSecondaryColor[3])
						boughtVehicleData = {
							primaryColor = vPrimaryColor,
							secondaryColor = vSecondaryColor
						}
					--[[elseif vPrimaryColor ~= nil and vSecondaryColor == nil then
						SetVehicleColours(boughtVehicle, actualPrimaryColor, actualSecondaryColor)
						SetVehicleCustomPrimaryColour(boughtVehicle, vPrimaryColor[1], vPrimaryColor[2], vPrimaryColor[3])
						boughtVehicleData = {
							primaryColor = vPrimaryColor,
							secondaryColor = actualSecondaryColor
						}
					elseif vPrimaryColor == nil and vSecondaryColor ~= nil then
						SetVehicleColours(boughtVehicle, actualPrimaryColor, actualSecondaryColor)
						SetVehicleCustomSecondaryColour(boughtVehicle, vSecondaryColor[1], vSecondaryColor[2], vSecondaryColor[3])
						boughtVehicleData = {
							primaryColor = actualPrimaryColor,
							secondaryColor = vSecondaryColor
						}
					elseif vPrimaryColor == nil and vSecondaryColor == nil then
						SetVehicleColours(boughtVehicle, actualPrimaryColor, actualSecondaryColor)
						boughtVehicleData = {
							primaryColor = actualPrimaryColor,
							secondaryColor = actualSecondaryColor
						}]]--
					end
					for k, v in ipairs(Config.Vehicles) do
						if data.selectedVehicle == v.name then
							boughtVehicleData.plate = GetVehicleNumberPlateText(boughtVehicle)
							TriggerServerEvent("boughtCar", boughtVehicle, v.name, v.label, v.type, v.price, boughtVehicleData)
						end
					end
					vPrimaryColor, vSecondaryColor = nil, nil
				end)
			else
				-- Add to garage without spawning
				TriggerEvent('_drawtextui:ShowNotify', 'error', 2000, "Spawn point isn't clear")
			end
		end
	else
		TriggerEvent('_drawtextui:ShowNotify', 'error', 3000, "Selected vehicle doesn't have any color.")
		SetNuiFocus(false, false)
		DeleteEntity(GetVehiclePedIsIn(GetPlayerPed(-1), false))
		Wait(100)
		ESX.Game.Teleport(GetPlayerPed(-1), Config.Dealerships[1].shopEntering)
	end
	--cb('ok')
end)

RegisterNUICallback('handleEscape', function(data, cb)
	SetNuiFocus(false, false)
	DeleteEntity(GetVehiclePedIsIn(GetPlayerPed(-1), false))
	Wait(100)
	ESX.Game.Teleport(GetPlayerPed(-1), Config.Dealerships[1].shopEntering)
	--TriggerEvent('_drawtextui:ShowUI', 'show', "[ ".. GetControlInstructionalButton(0, 0x8ced1179, 1):gsub("t_", "").." ] ".."Vehicle Shop")
	--cb('ok')
end)

RegisterNUICallback('startTestDrive', function(data, cb)
	SetNuiFocus(false, false)
	for k,v in ipairs(Config.Dealerships) do
		if ESX.Game.IsSpawnPointClear(v.testdriveSpawn, 3) then
			local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			DeleteEntity(veh)
			Wait(100)
			-- TODO: test if vehicle is not visible to other players
			ESX.Game.SpawnLocalVehicle(data.selectedVehicle, vector3(v.testdriveSpawn.x, v.testdriveSpawn.y, v.testdriveSpawn.z), v.testdriveSpawn.w, function(testdriveVehicle)
				isOnTestDrive = true
				TaskWarpPedIntoVehicle(GetPlayerPed(-1), testdriveVehicle, -1)
				Wait(1000)
				TriggerEvent('_drawtextui:ShowNotify', 'info', 3500, math.floor(Config.TestDriveTimer / 60).." minutes timer test trive started!")
				TriggerEvent('startTimer', testdriveVehicle, v.shopEntering)
			end)
		else
			TriggerEvent('_drawtextui:ShowNotify', 'error', 2000, "Spawn point isn't clear")
		end
	end
	--cb('ok')
end)

local lastSelectedVehicle = nil
RegisterNUICallback('handleVehicleSelect', function(data, cb)
	print(data.selectedVehicle)
	for k,v in ipairs(Config.Dealerships) do
		if ESX.Game.IsSpawnPointClear(v.showroomSpawn, 2) then
			ESX.Game.SpawnLocalVehicle(data.selectedVehicle, vector3(v.showroomSpawn.x, v.showroomSpawn.y, v.showroomSpawn.z), v.showroomSpawn.w, function(previewVehicle)
				TaskWarpPedIntoVehicle(GetPlayerPed(-1), previewVehicle, -1)
				lastSelectedVehicle = previewVehicle
			end)
		else
			if lastSelectedVehicle ~= nil then
				DeleteEntity(lastSelectedVehicle)
				Wait(100)
				ESX.Game.SpawnLocalVehicle(data.selectedVehicle, vector3(v.showroomSpawn.x, v.showroomSpawn.y, v.showroomSpawn.z), v.showroomSpawn.w, function(previewVehicle)
					TaskWarpPedIntoVehicle(GetPlayerPed(-1), previewVehicle, -1)
					lastSelectedVehicle = previewVehicle
				end)
			end
		end
	end
	print(data.selectedVehicle, lastSelectedVehicle)
	--cb('ok')
end)

RegisterNUICallback('changeColor', function(data, cb)
	local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
	if data.colorType == 0 then
		SetVehicleCustomPrimaryColour(veh, data.color[1], data.color[2], data.color[3])
		vPrimaryColor = data.color
	else
		SetVehicleCustomSecondaryColour(veh, data.color[1], data.color[2], data.color[3])
		vSecondaryColor = data.color
	end
	--cb('ok')
end)

RegisterNetEvent("openVehicleshop")
AddEventHandler("openVehicleshop", function()
    SendNUIMessage({
		showMenu = true,
		useStocks = Config.UseStocks,
		vehiclesList = Config.Vehicles
	})
	SetNuiFocus(true, true)
end)

function getServerVehicles()
	return Config.Vehicles
end