local firstSpawn = true
local resourceNames = {}
tokenReceived = false

Core.Modules.Tokenizer = {
	SetupClientResource = function(self, resource)
		local token = false

		if Core.Config.Tokenizer.Verbose then
			Core.Modules.Logger:Warn('Tokenizer', "Deploying Obfuscated Event: " .. tostring(resource) .. " = " .. tostring(Core.Modules.Tokenizer:RequestObfuscatedEventName(resource)))
		end
		RegisterNetEvent(Core.Modules.Tokenizer:RequestObfuscatedEventName(resource))
		AddEventHandler(Core.Modules.Tokenizer:RequestObfuscatedEventName(resource), function(tokenReceived)
			token = tokenReceived
			if Core.Config.Tokenizer.Verbose then
				Core.Modules.Logger:Warn('Tokenizer', "Obfuscated Event Token Received: " .. tostring(resource) .. " (" .. tostring(Core.Modules.Tokenizer:RequestObfuscatedEventName(resource)) .. "), Token: " .. tostring(token))
			end
			Core.Config.SecurityTokenReceived = true
		end)
		while not token do
			Citizen.Wait(0)
		end
		return token
	end,
	GenerateId = function(self)
		local id = math.random(1,100000)
		while not validId(id) do
			id = math.random(1,100000)
			if Core.Config.Tokenizer.Verbose then
				Core.Modules.Logger:Warn('Tokenizer', "ID Collision, Generating New ID")
			end
		end
		return id
	end,
	RequestObfuscatedEventName = function(self, resource)
		if resourceNames[resource] == nil then
			resourceNames[resource] = { id = self:GenerateId(), name = false }
			TriggerServerEvent('Core:Token:Server:RequestObfuscation', resource, resourceNames[resource].id)
			while not resourceNames[resource].name do
				Citizen.Wait(0)
			end
		end
		return resourceNames[resource].name
	end,
	EventReceived = function(self, id, name)
		for resource,property in pairs(resourceNames) do
			if property.id == id then
				property.name = name
				break
			end
		end
	end
}

function validId(id)
	if #resourceNames > 0 then
		for resource,property in pairs(resourceNames) do
			if property.id == id then
				return false
			end
		end
	end
	return true
end