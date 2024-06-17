local lastPlayerSuccess = {}

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'taxi', Config.MaxInService)
end

exports._core:RegisterJob({
	name = "taxi",
	label = "Taxi",
	grades = {
		driver = {
			salary = 300,
			label = "Driver",
		},
		uber = {
			salary = 500,
			label = "Uber",
		},
		boss = {
			boss = true,
			label = "Boss",
			salary = 1000
		},
	},
	boss = {
		model = "A_M_Y_Business_03",
		location = { x = 894.88, y = -180.23, z = 74.5 },
		heading = 328.3701477050781,
	}
})

exports._core:RegisterFleet("taxi", {
	location = vector3(902.93542480469, -169.90539550781, 74.086921691895),
	heading = 224.6103668212891,
	vehicles = {
		['taxi'] = {
			model = 'taxi',
			label = "Taxi",
			price = 10000,
			level = 0
		}
	},
	spawns = {
		{
			location = vector3(918.44891357422, -167.15582275391, 74.631729125977),
			heading = 277.5821533203125
		},
		{
			location = vector3(913.74755859375, -160.25440979004, 74.735427856445),
			heading = 11.33712577819824
		}
	}
})

--TriggerEvent('esx_phone:registerNumber', 'taxi', _U('taxi_client'), true, true)
--TriggerEvent('esx_society:registerSociety', 'taxi', 'Taxi', 'society_taxi', 'society_taxi', 'society_taxi', { type = 'public' })

RegisterNetEvent('prp-taxijob:success')
AddEventHandler('prp-taxijob:success', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local timeNow = os.clock()

	if xPlayer.job.name == 'taxi' then
		if not lastPlayerSuccess[source] or timeNow - lastPlayerSuccess[source] > 5 then
			lastPlayerSuccess[source] = timeNow

			math.randomseed(os.time())
			local total = math.random(Config.NPCJobEarnings.min, Config.NPCJobEarnings.max)

			if xPlayer.job.grade >= 3 then
				total = total * 2
			end

			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_taxi', function(account)
				if account then
					local playerMoney = ESX.Math.Round(total / 100 * 30)
					local societyMoney = ESX.Math.Round(total / 100 * 70)

					xPlayer.addMoney(playerMoney)
					account.addMoney(societyMoney)

					xPlayer.showNotification(_U('comp_earned', societyMoney, playerMoney))
				else
					xPlayer.addMoney(total)
					xPlayer.showNotification(_U('have_earned', total))
				end
			end)
		end
	else
		print(('[prp-taxijob] [^3WARNING^7] %s attempted to trigger success (cheating)'):format(xPlayer.identifier))
	end
end)

RegisterNetEvent('prp-taxijob:getStockItem')
AddEventHandler('prp-taxijob:getStockItem', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'taxi' then
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
			local item = inventory.getItem(itemName)

			-- is there enough in the society?
			if count > 0 and item.count >= count then
				-- can the player carry the said amount of x item?
				if xPlayer.canCarryItem(itemName, count) then
					inventory.removeItem(itemName, count)
					xPlayer.addInventoryItem(itemName, count)
					xPlayer.showNotification(_U('have_withdrawn', count, item.label))
				else
					xPlayer.showNotification(_U('player_cannot_hold'))
				end
			else
				xPlayer.showNotification(_U('quantity_invalid'))
			end
		end)
	else
		print(('[prp-taxijob] [^3WARNING^7] %s attempted to trigger getStockItem'):format(xPlayer.identifier))
	end
end)

ESX.RegisterServerCallback('prp-taxijob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterNetEvent('prp-taxijob:putStockItems')
AddEventHandler('prp-taxijob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'taxi' then
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
			local item = inventory.getItem(itemName)

			if item.count >= 0 then
				xPlayer.removeInventoryItem(itemName, count)
				inventory.addItem(itemName, count)
				xPlayer.showNotification(_U('have_deposited', count, item.label))
			else
				xPlayer.showNotification(_U('quantity_invalid'))
			end
		end)
	else
		print(('[prp-taxijob] [^3WARNING^7] %s attempted to trigger putStockItems'):format(xPlayer.identifier))
	end
end)

ESX.RegisterServerCallback('prp-taxijob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items = xPlayer.inventory

	cb({ items = items })
end)
