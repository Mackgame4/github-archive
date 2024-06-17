-- [[ Mensagens ]] --

RegisterNetEvent( 'sendTweet' )
AddEventHandler( 'sendTweet', function(character, message) 
	TriggerEvent("chatMessage", "[Twitter] - " .. character, { 0, 172, 237 }, message)
end)

RegisterNetEvent( 'sendNotification' )
AddEventHandler( 'sendNotification', function(message)
    drawNotification("~b~" .. message)
end)

RegisterNetEvent( 'sendOOC' )
AddEventHandler( 'sendOOC', function(id, name, message) 
	TriggerEvent("chatMessage", "[OOC] - [" .. id .. "] " .. name, { 96, 96, 96 }, message)
end)

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(true, false)
end

local function trim(s)
  return s:match'^%s*(.*%S)' or ''
end