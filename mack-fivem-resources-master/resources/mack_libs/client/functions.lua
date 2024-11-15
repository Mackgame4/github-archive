ML.Client.SpawnObject = function(object)
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
	local heading = GetEntityHeading(GetPlayerPed(-1))
	local model = GetHashKey(object)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(1)
	end
	local obj = CreateObject(model, x, y, z, true, true, true)
	SetEntityHeading(obj, heading)
	PlaceObjectOnGroundProperly(obj)
	SetEntityAsMissionEntity(obj, true, true)
end

local cachedPlayer = nil
ML.Client.GetPlayer = function()
	if cachedPlayer ~= nil and cachedPlayer == ML.Client.Player then
		return ML.Client.Player
	else
		TriggerServerEvent('mack_libs:getPlayer')
		while not ML.Client.Player do
			Citizen.Wait(1)
		end
		cachedPlayer = ML.Client.Player
		return ML.Client.Player
	end
end

ML.Client.GetPlayerCoords = function()
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    return x, y, z
end