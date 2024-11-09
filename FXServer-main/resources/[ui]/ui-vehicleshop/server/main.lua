RegisterServerEvent("boughtCar")
AddEventHandler("boughtCar", function(newVehicle, newVehicleName, newVehicleLabel, newVehicleType, newVehiclePrice, newVehicleData)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = ESX.GetIdentifier(source)
    local newVehicleStatus = { inGarage = false, handling = 70, topspeed = 100, acceleration = 85, hp = 80, torque = 55, brake = 70, engine = 25, body = 80 }
    if newVehiclePrice and xPlayer.getMoney() >= newVehiclePrice then
		xPlayer.removeMoney(newVehiclePrice)
        exports.mongodb:updateOne({ collection="users", query = { identifier = identifier }, update = { ["$push"] = { ownedVehicles = '{"label":"'..newVehicleLabel..'","name":"'..newVehicleName..'","type":"'..newVehicleType..'","data":' ..json.encode(newVehicleData)..'","status":' ..json.encode(newVehicleStatus)..'}' } } })
        TriggerClientEvent('_drawtextui:ShowNotify', _source, 'success', 3500, "The "..newVehicleLabel.." ("..newVehicleData.plate..") is now yours, enjoy!")
    elseif newVehiclePrice and xPlayer.getAccount('bank').money >= newVehiclePrice then
		xPlayer.removeAccountMoney('bank', newVehiclePrice)
        exports.mongodb:updateOne({ collection="users", query = { identifier = identifier }, update = { ["$push"] = { ownedVehicles = '{"label":"'..newVehicleLabel..'","name":"'..newVehicleName..'","type":"'..newVehicleType..'","data":' ..json.encode(newVehicleData)..'","status":' ..json.encode(newVehicleStatus)..'}' } } })
        TriggerClientEvent('_drawtextui:ShowNotify', _source, 'success', 3500, "The "..newVehicleLabel.." ("..newVehicleData.plate..") is now yours, enjoy!")
    else
        TriggerClientEvent('_drawtextui:ShowNotify', _source, 'error', 3500, "You don't have enough money to buy a "..newVehicleLabel..".")
        -- TODO: Fix this lazy fix
        TriggerClientEvent("deleteVehicle", _source, newVehicle)
    end
end)