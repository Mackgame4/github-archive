local didPlayerLoad = {}
local resourceNames = {}
local resourceTokens = {}
local initComplete = false

function isTokenUnique(token)
	if #resourceNames > 0 then

		for i=1, #resourceNames, 1 do
			if resourceNames[i] ~= nil then
				for id,resource in pairs(resourceNames[i]) do
					if resource == token then
						if Core.Config.Tokenizer.Verbose then
                            Core.Modules.Logger:Warn('Tokenizer', "Token collision, generating new token.")
						end
						return false
					end
				end
			end
		end

		for resource,storedToken in pairs(resourceTokens) do
			if storedToken == token then
				if Core.Config.Tokenizer.Verbose then
                    Core.Modules.Logger:Warn('Tokenizer', "Token collision, generating new token.")
				end
				return false
			end
		end

	end
	return true
end

RegisterNetEvent('Core:Token:Server:RequestObfuscation')
AddEventHandler('Core:Token:Server:RequestObfuscation', function(resourceName, id)
	local _source = source
    Core.Modules.Execute:Client(_source, 'Tokenizer', 'EventReceived', id, Core.Modules.Tokenizer:GetObfuscatedEvent(_source, resourceName))
end)

RegisterNetEvent('Core:Token:Server:PlayerSpawned')
AddEventHandler('Core:Token:Server:PlayerSpawned', function()
	local _source = source
	initComplete = true
	
	Core.Modules.Tokenizer:NewPlayer(_source)
	
	if not didPlayerLoad[_source] then
		didPlayerLoad[_source] = true
		if Core.Config.Tokenizer.Verbose then
            Core.Modules.Logger:Info('Tokenizer', "Player ID " .. tostring(_source) .. " loaded.")
		end
		TriggerEvent('Core:Token:Server:PlayerLoaded', _source)
	else
        Core.Modules.Logger:Warn('Tokenizer', "Player ID " .. tostring(_source) .. " requested another security token, potential cheater?")
	end
end)

AddEventHandler('onServerResourceStart', function (resource)
	if resource == GetCurrentResourceName() then
        if Core.Config.Tokenizer.Verbose then
            Core.Modules.Logger:Info('Tokenizer', "> > > D E B U G   M O D E   E N A B L E D  < < <")
        end
	    Core.Modules.Tokenizer:SetupServerResource(resource)
	elseif resourceTokens[resource] ~= nil and initComplete then
		if Core.Config.Tokenizer.Verbose then
            Core.Modules.Logger:Warn('Tokenizer', resource .. " was restarted and is no longer protected with security tokens!")
		end
		resourceTokens[resource] = nil
	end
end)

AddEventHandler("playerDropped", function(player, reason)
	local _source = source
	if Core.Config.Tokenizer.Verbose then
        Core.Modules.Logger:Info('Tokenizer', "Player ID " .. tostring(_source) .. " dropped, purged obfuscated events.")
	end
	didPlayerLoad[_source] = false
	resourceNames[_source] = {}
end)

Core.Modules.Tokenizer = {
    NewPlayer = function(self, source)
        if didPlayerLoad[source] == nil or resourceNames[source] == nil then
            didPlayerLoad[source] = false
            resourceNames[source] = {}
        end
    end,
    ValidateToken = function(self, token, player, resource)
        local _source = player
        if resourceTokens[resource] == nil then
            return true
        elseif _source == "" then
            return true
        else
            if Core.Config.Tokenizer.Verbose then
                Core.Modules.Logger:Info('Tokenizer', "Validating token for " .. tostring(resource) .. " for Player ID " .. tostring(_source) .. ". Provided: " .. tostring(token) .. " Stored: " .. tostring(resourceTokens[resource]))
            end
            if token ~= resourceTokens[resource] then
                if Core.Config.Tokenizer.Verbose then
                    Core.Modules.Logger:Warn('Tokenizer', "Invalid token detected! Resource: " .. tostring(resource) .. ", Player ID: " .. tostring(_source) .. ". Provided: " .. tostring(token) .. " Stored: " .. tostring(resourceTokens[resource]))				
                end
                DropPlayer(_source, "You have been disconnected due to security being compromised")
                return false
            end
        end
        return true
    end,
    SetupServerResource = function(self, resource)
        resourceTokens[resource] = exports[GetCurrentResourceName()]:GenerateUUID()
        if Core.Config.Tokenizer.Verbose then
            Core.Modules.Logger:Info('Tokenizer', "Generated token for resource " .. tostring(resource) .. ": " .. tostring(resourceTokens[resource]))
        end
        AddEventHandler('Core:Token:Server:PlayerLoaded', function(player)
            local _source = player
            if Core.Config.Tokenizer.Verbose then
                Core.Modules.Logger:Info('Tokenizer', "Sending token for " .. tostring(resource) .. " (Event: " .. tostring(Core.Modules.Tokenizer:GetObfuscatedEvent(_source, resource)) .. " Token: " .. tostring(resourceTokens[resource]) .. ") to Player ID " .. tostring(_source) .. ".")
            end
            TriggerClientEvent(Core.Modules.Tokenizer:GetObfuscatedEvent(_source, resource), _source, resourceTokens[resource])
        end)
    end,
    GetResourceToken = function(self, res)
        return resourceTokens[resourceName]
    end,
    GetObfuscatedEvent = function(self, source, resourceName)
        Core.Modules.Tokenizer:NewPlayer(source)
        if resourceNames[source][resourceName] == nil then
            resourceNames[source][resourceName] = exports[GetCurrentResourceName()]:GenerateUUID()
            if Core.Config.Tokenizer.Verbose then
                Core.Modules.Logger:Info('Tokenizer', "Obfuscated Event for Player ID " .. tostring(source) .. ": Original - " .. tostring(resourceName) .. " Obfuscated - "  .. tostring(resourceNames[source][resourceName]))
            end
        end
        return(resourceNames[source][resourceName])
    end
}