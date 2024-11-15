--[[if GetConvar("debug") then
	RegisterCommand('enabledebug', function(source, args)
		TriggerClientEvent("hud:enabledebug", source)
	end)
end]]--