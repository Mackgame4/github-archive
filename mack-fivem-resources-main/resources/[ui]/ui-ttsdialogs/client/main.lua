local isFocused = false

RegisterCommand('openUI', function()
	isFocused = not isFocused
	SetNuiFocus(isFocused, isFocused)
end, false)

RegisterCommand('sendDialog', function()
	local dialog = {
		{
			text = "Ho no! Josh is in trouble at the docks. Go help him before he gets hurt!",
			character = "Dave"
		},
		{
			text = "Okay im going!",
			character = "Amy"
		},
		{
			text = "Cool!",
			character = "Dave"
		},
		{
			text = "Thanks!",
			character = "Amy"
		}
	}
	SendNUIMessage({
		action = "startDialog",
		dialog = dialog
	})
end, false)

RegisterCommand('pauseDialog', function()
	SendNUIMessage({
		action = "pauseDialog"
	})
end, false)

RegisterCommand('resumeDialog', function()
	SendNUIMessage({
		action = "resumeDialog"
	})
end, false)

RegisterCommand('getVoiceList', function()
	SendNUIMessage({
		action = "getVoiceList"
	})
	RegisterNUICallback('getVoiceList', function(data, cb)
		print('getVoiceList', data)
		cb('ok')
	end)
end, false)

RegisterNUICallback('dialogStarted', function(data, cb)
	print('dialogStarted', data)
	cb('ok')
end)

RegisterNUICallback('speechStarted', function(data, cb)
	print('speechStarted', data)
	cb('ok')
end)

RegisterNUICallback('dialogEnded', function(data, cb)
	print('dialogEnded', data)
	cb('ok')
end)

RegisterNUICallback('speechEnded', function(data, cb)
	print('speechEnded', data)
	cb('ok')
end)