ESX = nil

TriggerEvent('CLYDOsx:getSharedObject', function(obj) ESX = obj end)

local weapons = {
	GetHashKey('WEAPON_KNIFE'),
	GetHashKey('WEAPON_NIGHTSTICK'),
	GetHashKey('WEAPON_HAMMER'),
	GetHashKey('WEAPON_BAT'),
	GetHashKey('WEAPON_GOLFCLUB'),
	GetHashKey('WEAPON_CROWBAR'),
	GetHashKey('WEAPON_BOTTLE'),
	GetHashKey('WEAPON_DAGGER'),
	GetHashKey('WEAPON_HATCHET'),
	GetHashKey('WEAPON_MACHETE'),
	GetHashKey('WEAPON_BATTLEAXE'),
	GetHashKey('WEAPON_POOLCUE'),
	GetHashKey('WEAPON_WRENCH'),
	GetHashKey('WEAPON_PISTOL'),
	GetHashKey('WEAPON_COMBATPISTOL'),
	GetHashKey('WEAPON_APPISTOL'),
	GetHashKey('WEAPON_PISTOL50'),
	GetHashKey('WEAPON_REVOLVER'),
	GetHashKey('WEAPON_SNSPISTOL'),
	GetHashKey('WEAPON_HEAVYPISTOL'),
	GetHashKey('WEAPON_VINTAGEPISTOL'),
	GetHashKey('WEAPON_MICROSMG'),
	GetHashKey('WEAPON_SMG'),
	GetHashKey('WEAPON_ASSAULTSMG'),
	GetHashKey('WEAPON_MINISMG'),
	GetHashKey('WEAPON_MACHINEPISTOL'),
	GetHashKey('WEAPON_COMBATPDW'),
	GetHashKey('WEAPON_PUMPSHOTGUN'),
	GetHashKey('WEAPON_SAWNOFFSHOTGUN'),
	GetHashKey('WEAPON_ASSAULTSHOTGUN'),
	GetHashKey('WEAPON_BULLPUPSHOTGUN'),
	GetHashKey('WEAPON_HEAVYSHOTGUN'),
	GetHashKey('WEAPON_ASSAULTRIFLE'),
	GetHashKey('WEAPON_CARBINERIFLE'),
	GetHashKey('WEAPON_ADVANCEDRIFLE'),
	GetHashKey('WEAPON_SPECIALCARBINE'),
	GetHashKey('WEAPON_BULLPUPRIFLE'),
	GetHashKey('WEAPON_COMPACTRIFLE'),
	GetHashKey('WEAPON_MG'),
	GetHashKey('WEAPON_COMBATMG'),
	GetHashKey('WEAPON_GUSENBERG'),
	GetHashKey('WEAPON_RPG'),
	GetHashKey('WEAPON_STINGER'),
	GetHashKey('WEAPON_GRENADE'),
	GetHashKey('WEAPON_SMOKEGRENADE'),
	GetHashKey('WEAPON_BZGAS'),
	GetHashKey('WEAPON_MOLOTOV'),
	GetHashKey('WEAPON_DIGISCANNER'),
	GetHashKey('WEAPON_MUSKET'),
	GetHashKey('WEAPON_STUNGUN'),
	GetHashKey('WEAPON_MARKSMANPISTOL'),
	GetHashKey('WEAPON_DBSHOTGUN'),
	GetHashKey('WEAPON_AUTOSHOTGUN'),
	GetHashKey('WEAPON_DOUBLEACTION'),
}
--IsEntityAttachedToEntity(from, to)
--
RegisterNUICallback('print', function(data, cb)
    PrintTable(data)
    cb('OK')
end)

local SETTINGS = {
    back_bone = 24816,
    x = 0.075,
    y = -0.15,
    z = -0.02,
    x_rotation = 0.0,
    y_rotation = 165.0,
    z_rotation = 0.0,
    compatable_weapon_hashes = {
		-- melee:
		["w_me_bat"] = -1786099057,

		-- assault rifles:
		["w_ar_carbinerifle"] = -2084633992,
		["w_ar_carbineriflemk2"] = GetHashKey("WEAPON_CARBINERIFLE_Mk2"),
		["w_ar_assaultrifle"] = -1074790547,
		--["w_ar_specialcarbine"] = -1063057011,
		["w_ar_bullpuprifle"] = 2132975508,
		["w_ar_advancedrifle"] = -1357824103,

		-- sub machine guns:
		["w_sb_assaultsmg"] = -270015777,
		["w_sb_smg"] = 736523883,
		["w_sb_smgmk2"] = GetHashKey("WEAPON_SMGMk2"),
		["w_sb_gusenberg"] = 1627465347,
		["w_sb_pdw"] = GetHashKey('WEAPON_COMBATPDW'),
		["w_ar_assaultrifle_smg"] = GetHashKey("WEAPON_COMPACTRIFLE"),

		-- sniper rifles:
		["w_sr_sniperrifle"] = 100416529,

		-- shotguns:
		["w_sg_assaultshotgun"] = -494615257,
		["w_sg_bullpupshotgun"] = -1654528753,
		["w_sg_pumpshotgun"] = 487013001,
		["w_ar_musket"] = -1466123874,
		["w_sg_heavyshotgun"] = GetHashKey("WEAPON_HEAVYSHOTGUN")
    }
}

local PlayerInv = {}
local attached_weapons = {}
local isCop = false

AddEventHandler('prp-inventory:givePlayerInventory', function(inv, src, identifier)
	PlayerInv = {}
	for k,v in pairs(inv.inventory) do
		for _k,_v in pairs(weapons) do
			if _v == GetHashKey(v.itemId) then
				table.insert(PlayerInv, _v)
			end
		end
	end
end)

CreateThread(function()
 	while true do
		for wep_name, wep_hash in pairs(SETTINGS.compatable_weapon_hashes) do
			if PlayerGotWeapon(wep_hash) then
				if not attached_weapons[wep_name] then
					print('attaching '..wep_name)
					AttachWeapon(wep_name, wep_hash, SETTINGS.back_bone, SETTINGS.x, SETTINGS.y, SETTINGS.z, SETTINGS.x_rotation, SETTINGS.y_rotation, SETTINGS.z_rotation, isMeleeWeapon(wep_name))
				end
			end
		end

		for name, attached_object in pairs(attached_weapons) do
			if (GetSelectedPedWeapon(PlayerPedId()) == attached_object.hash) or (not PlayerGotWeapon(attached_object.hash)) then -- equipped or not in weapon wheel
				DeleteObject(attached_object.handle)
				attached_weapons[name] = nil
			end
		end

 		Wait(0)
 	end
end)


function AttachWeapon(attachModel,modelHash,boneNumber,x,y,z,xR,yR,zR, isMelee)
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumber)

	RequestModel(attachModel)

	while not HasModelLoaded(attachModel) do
		Wait(100)
	end

	attached_weapons[attachModel] = {
		hash = modelHash,
		handle = CreateObject(GetHashKey(attachModel), 1.0, 1.0, 1.0, true, true, false)
	}
	
	if isMelee then x = 0.11 y = -0.14 z = 0.0 xR = -75.0 yR = 185.0 zR = 92.0 end -- reposition for melee items
	if attachModel == "prop_ld_jerrycan_01" then x = x + 0.3 end
	if attachModel == "w_ar_assaultrifle"  then x = x + 0.2  end
	if attachModel == "w_ar_carbinerifle" then x = x + 0.1  end
	if attachModel == "w_sb_gusenberg" then x = x + 0.1  end
	if attachModel == "w_sr_sniperrifle" then x = x + 0.3  end
	if attachModel == "w_sg_pumpshotgun" then x = x + 0.1  end
	if attachModel == "w_ar_musket" then x = x + 0.3  end

	AttachEntityToEntity(attached_weapons[attachModel].handle, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
end

function isMeleeWeapon(wep_name)
    if wep_name == "prop_golf_iron_01" then
        return true
    elseif wep_name == "w_me_bat" then
        return true
    elseif wep_name == "prop_ld_jerrycan_01" then
    	return true
    else
        return false
    end
end

function PlayerGotWeapon(wep)
	for k,v in pairs(PlayerInv) do
		if v == wep then
			return true
		end
	end
	return false
end

RegisterCommand('clearweapons', function(source, cb)
	for name, attached_object in pairs(attached_weapons) do
		DeleteObject(attached_object.handle)
		attached_weapons[name] = nil
	end
end)