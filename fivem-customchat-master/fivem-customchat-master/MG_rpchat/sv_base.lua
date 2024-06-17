local command = tweet
local blacklistCommands = {'/fix', '/car', '/dv'}


AddEventHandler( 'chatMessage', function(source, n, message)
    CancelEvent()
    checkIfCommand(message)

    if (command == "tweet") then
    	sendTweets(source, GetPlayerName(source), message)
	elseif (command == "ooc") then
    	sendOOCs(source, GetPlayerName(source), message:sub(5))
    elseif (command == "blacklist") then
    	return
	end
end)

function sendTweets(source, name, message)
	TriggerClientEvent('sendNotification', source, "Aguardando rede...")
	Citizen.Wait(1200)
	TriggerClientEvent('sendTweet', -1, name, message)
	TriggerClientEvent('sendNotification', source, "Tweet mandado")
end

function sendOOCs(id, name, message)
	Citizen.Wait(0)
	TriggerClientEvent('sendOOC', -1, id, name, message)
end

function checkIfCommand(message)
	if string.starts(message, "/ooc") then
		command = "ooc"
	else
		command = "tweet"
	end

	for i, cmd in ipairs(blacklistCommands) do
		if (message == cmd) then
			command = "blacklist"
		end
	end
end

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end
