RegisterNetEvent('_menu:handleMenu')
AddEventHandler('_menu:handleMenu', function(action, type, title, subtitle, data, buttons)
	SendNUIMessage({
		action = action,
		type = type,
		title = title,
		subtitle = subtitle,
		data = data,
		buttons = buttons
	})
	if action == 'show' then
		SetNuiFocus(true, true)
	else
		SetNuiFocus(false, false)
	end
end)

RegisterNUICallback('handleMenuAction', function(data, cb)
	TriggerEvent('_menu:handleEvent:'..data.action, data.value)
	cb('ok')
end)