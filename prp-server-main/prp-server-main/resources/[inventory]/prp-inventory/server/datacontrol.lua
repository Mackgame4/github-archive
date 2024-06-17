
local InvData = nil

local WipeBlacklist = {
    ['WEAPON_SWITCHBLADE'] = true,
    ['WEAPON_KNUCKLES'] = true,
    ['WEAPON_BATTLEAXE'] = true,
    ['WEAPON_SNIPER'] = true,
}



function GetInventory()
    MySQL.ready(function()
        MySQL.Async.fetchAll('SELECT * FROM `prp-inventory`', {}, function(result)
            InvData = result
        end)
    end)
end

local drugs = {
    ["weed"] = true,
    ["weed_pooch"] = true,
    ["meth"] = true,
    ["meth_pooch"] = true,
    ["opium"] = true,
    ["opium_pooch"] = true,
    ["coke"] = true,
    ["coke_pooch"] = true,
    ["oxy"] = true,
    ["morphine"] = true,
    ["pistol_ammo"] = true,
    ["shotgun_ammo"] = true,
    ["sub_ammo"] = true,
    ["rifle_ammo"] = true,
    ["advanced_lockpick"] = true,
}

function shouldWipe(name)
    return drugs[name] ~= nil
end

function GunWipe()
	
    if InvData == nil then
        GetInventory()
        Citizen.Wait(100)
        GunWipe()
        return
    end
    print('Starting Wipe for ' .. #InvData .." inventories")

    local data = InvData
    local max = #InvData
    local toUpdate = 0
    local totalGuns = 0
    local totalItems = 0

    for k,v in pairs(data) do
    	print("Checking inventory #" ..k .."/" ..max ..' inv id: ' ..v.id)
    	local inventory = {}
    	local update = false

		inventory = json.decode(v.data)
		local newInventory = {}

        for _k,_v in pairs(inventory) do
            if isWeapon(_v.name) and (WipeBlacklist[_v.name] == nil) then
                totalGuns = totalGuns + 1
                update = true
                inventory[_k] = nil
                print('Removing ' .._v.name ..' from inventory # ' ..v.id)
            end
            if shouldWipe(_v.name) and (WipeBlacklist[_v.name] == nil) then
                totalItems = totalItems + _v.count
                update = true
                inventory[_k] = nil
                print('Removing ' .._v.name ..' from inventory # ' ..v.id)
            end
        end
        for k,v in pairs(inventory) do
        	if k ~= nil and v ~= nil then
        		newInventory[k] = v
        	end
        end

        if update == true then
        	toUpdate = toUpdate + 1
	        MySQL.Async.execute('UPDATE `prp-inventory` SET `data`= @data WHERE `id` = @id', {
	            ['@data'] = json.encode(newInventory),
	            ['@id'] = v.id
	        })
            exports.mongodb:updateOne({ collection = "inventory", query = { id = v.id }, update = { ["$set"] = { data = data } } })
	    end
    end
    print("The matrix has snapped " ..toUpdate .." inventories for a total of " ..totalGuns ..' guns and ' ..totalItems ..' items.')
end

RegisterCommand('wipeguns', GunWipe, true)


function FindDuplicateSerialNumbers()
    if InvData == nil then
        GetInventory()
        Citizen.Wait(100)
        FindDuplicateSerialNumbers()
        return
    end

    print("Starting Search")
    local RegisteredSerials = {}
    local Duplicates = {}
    
    for k,v in pairs(InvData) do
        local inventory = json.decode(v.data) 
        for _k,_v in pairs(inventory) do
            if (_v.staticMeta ~= nil) and (_v.staticMeta.serial ~= nil) then 
                RegisteredSerials[_v.staticMeta.serial] = {
                    id = v.id,
                    owner = v.owner,
                    data = v.data,
                    slot = _k,
                    item = _v.name,
                }
            end
        end
    end

    for k,v in pairs(RegisteredSerials) do
        for _k,_v in pairs(RegisteredSerials) do
            if (k == _k) and (v.name == _v.name) then
                if (v.id ~= _v.id) or (v.slot ~= _v.slot) then
                    print('============================================')
                    print('THERE IS A DUPLICATE SERIAL NUMBER:')
                    print(' ITEM:['..v.name..'] SERIAL:['..k..'] ')
                    print(' OWNER1:['..v.owner..'] SLOT:['..v.slot..']')
                    print(' OWNER2:['.._v.owner..'] SLOT:['.._v.slot..']')
                    print('============================================')

                    Duplicates[k] = v
                    Duplicates[_k] = _v
                end
            end
        end
    end
    print("Finishing Search")

    return Duplicates
end


RegisterCommand('finddupes', FindDuplicateSerialNumbers, true)

function DBInventoryCleanUp()
    MySQL.ready(function()
        print('Initiating very slow but unrisky clean up!')
        local plates = MySQL.Sync.fetchAll('SELECT `plate` FROM `owned_vehicles`')
        local houses = MySQL.Sync.fetchAll('SELECT * FROM `housing`')
        local inventories = MySQL.Sync.fetchAll('SELECT * FROM `prp-inventory`')
        for k,v in pairs(inventories) do
            if string.find(v.type, 'trunk') or string.find(v.type,'glovebox') then
                local found = false
                for _k,_v in pairs(plates) do
                    if _v.plate == v.owner then
                        found = true
                    end
                    if not found then
                        MySQL.Sync.execute('DELETE FROM `prp-inventory` WHERE `owner`=@owner', {
                            ['owner'] = v.owner
                        })
                        print('Deleted', v.owner)
                    end
                end
            elseif string.find(v.type, 'property') then
                local found = false
                for _k,_v in pairs(houses) do
                    local houseStr = _v.id..'-'.._v.type
                    if houseStr == v.owner then
                        found = true
                    end
                    if not found then
                        MySQL.Sync.execute('DELETE FROM `prp-inventory` WHERE `owner`=@owner', {
                            ['owner'] = v.owner
                        })
                        print('Deleted', v.owner)
                    end
                end
            end
        end 
    end)
end

RegisterCommand('invcleanup', DBInventoryCleanUp, true)