local ESX      	 = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('CLYDOsx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
	AddEventHandler('esx:setJob', function(job)
  	PlayerData.job = job
end)


local currentWeapon
Weapons = {}

RegisterNetEvent('prp-inventory:useWeapon')
AddEventHandler('prp-inventory:useWeapon', function(weapon)
    local ped = PlayerPedId()
    local rerval, weaponHash = GetCurrentPedWeapon(ped)
    if currentWeapon == weapon then
        if weaponHash == GetHashKey(weapon) then
            RemoveWeapon(currentWeapon)
            RemoveAllPedWeapons(ped)
            currentWeapon = nil
            return
        end
    elseif currentWeapon ~= nil then
        RemoveWeapon(currentWeapon)
        RemoveAllPedWeapons(ped)
        currentWeapon = nil
	end
	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
		if not IsPedInAnyVehicle(ped, false) then
			if GetVehiclePedIsTryingToEnter (ped) == 0 and (GetPedParachuteState(ped) == -1 or GetPedParachuteState(ped) == 0) and not IsPedInParachuteFreeFall(ped) then
				SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
				TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "intro", 10.0, 2.3, -1, 49, 1, 0, 0, 0 )
				Citizen.Wait(600)
				SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
				TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
				Citizen.Wait(400)
				ClearPedTasks(ped)
			end
		end
	else
		SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
		TaskPlayAnim(ped, "reaction@intimidation@1h", "intro", 1.0, 1.0, -1, 50, 0, 0, 0, 0 )
		Citizen.Wait(900)
		SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
		Citizen.Wait(500)
		ClearPedTasks(ped)
	end
    currentWeapon = weapon
    GiveWeapon(currentWeapon)
    ClearPedTasks(ped)
end)

for name,item in pairs(Config.Weapons) do
    Weapons[GetHashKey(name)] = item
end

RegisterNetEvent('prp-inventory:removeCurrentWeapon')
AddEventHandler('prp-inventory:removeCurrentWeapon', function()
    if currentWeapon ~= nil then
        RemoveWeapon(currentWeapon)
        currentWeapon = nil
        ClearPedTasks(PlayerPedId())
    end
end)

function RemoveWeapon(weapon)
    local playerPed = GetPlayerPed(-1)
    local hash = GetHashKey(weapon)
	local ammoCount = GetAmmoInPedWeapon(playerPed, hash)
	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
		if not IsPedInAnyVehicle(playerPed, false) then
			if GetVehiclePedIsTryingToEnter (playerPed) == 0 and (GetPedParachuteState(playerPed) == -1 or GetPedParachuteState(playerPed) == 0) and not IsPedInParachuteFreeFall(playerPed) then
				TaskPlayAnim(playerPed, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
				Citizen.Wait(500)
				TaskPlayAnim(playerPed, "reaction@intimidation@cop@unarmed", "outro", 10.0, 2.3, -1, 49, 1, 0, 0, 0 )
				Citizen.Wait(60)
				ClearPedTasks(playerPed)
			end
		end
	else
		local dict = "reaction@intimidation@1h"
		local anim = "outro"
		local animLength = GetAnimDuration(dict, anim) * 1000
		TaskPlayAnim(playerPed, "reaction@intimidation@1h", "outro", 1.0, 1.0, -1, 50, 0, 0, 0, 0 )
		Citizen.Wait(animLength - 2200)
		ClearPedTasks(playerPed)
	end
    TriggerServerEvent('prp-inventory:updateAmmoCount', hash, ammoCount)
    RemoveWeaponFromPed(playerPed, hash)
end

function GiveWeapon(weapon)
    local checkh = Config.Throwables
    local playerPed = GetPlayerPed(-1)
    local hash = GetHashKey(weapon)

    if weapon == "WEAPON_PETROLCAN" then
        GiveWeaponToPed(playerPed, hash, 1, false, true)
        SetPedAmmo(playerPed, hash, 1000)
        return
    elseif weapon == "WEAPON_FIREEXTINGUISHER" then
        GiveWeaponToPed(playerPed, hash, 1, false, true)
        SetPedAmmo(playerPed, hash, 1000)
        return
    elseif weapon == "WEAPON_FLARE" then
        GiveWeaponToPed(playerPed, hash, 1, false, true)
        SetPedAmmo(playerPed, hash, 1)
        return
    end
    ESX.TriggerServerCallback('prp-inventory:getAmmoCount', function(ammoCount)
        GiveWeaponToPed(playerPed, hash, 1, false, true)

        if checkh[weapon] == hash then
            SetPedAmmo(playerPed, hash, 1)
        else
            SetPedAmmo(playerPed, hash, ammoCount or 0)
        end
    end, hash)
end

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(10)
		loadAnimDict("rcmjosh4")
		loadAnimDict("reaction@intimidation@cop@unarmed")
		loadAnimDict("reaction@intimidation@1h")
        if IsPedShooting(PlayerPedId()) then
            for k, v in pairs(Config.Throwables) do
                if k == currentWeapon then
                    TriggerServerEvent('np_marker:takePlayerItem', Weapons[GetHashKey(currentWeapon)].item)
                    break
                end
            end
        end
    end
end)

RegisterNetEvent('prp-inventory:handleWeapons')
AddEventHandler('prp-inventory:handleWeapons', function()
    RemoveAllPedWeapons(PlayerPedId(), false)
    currentWeapon = nil
end)

RegisterNetEvent('prp-inventory:checkWeapons')
AddEventHandler('prp-inventory:checkWeapons', function(items)
	Wait(2000)
	for k,v in pairs(items) do
		if v.id ~= nil and tostring(v.msg) == 'Removed' then
			if currentWeapon == tostring(v.id) then
				TriggerEvent('prp-inventory:handleWeapons')
				break
			end
		end
	end
end)

function CheckWeapon(ped)
	if IsEntityDead(ped) then
		return false
	else
		if GetHashKey(currentWeapon) == GetSelectedPedWeapon(ped) then
			return true
		end
		return false
	end
end


function loadAnimDict(dict)
	while ( not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(0)
	end
end