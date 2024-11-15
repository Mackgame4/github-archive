RegisterNetEvent('_drawtextui:ShowUI')
AddEventHandler('_drawtextui:ShowUI', function(action, text)
	SendNUIMessage({
		action = action,
		text = text,
	})
end)

RegisterNetEvent('_drawtextui:HideUI')
AddEventHandler('_drawtextui:HideUI', function()
	SendNUIMessage({
		action = 'hide'
	})
end)

RegisterNetEvent('_drawtextui:ShowNotify')
AddEventHandler('_drawtextui:ShowNotify', function(type, timeout, text)
	SendNUIMessage({
		action = 'notify',
		type = type,
		timeout = timeout,
		text = text
	})
end)