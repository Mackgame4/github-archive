if Debug then
RegisterCommand("sendnotify", function()
	TriggerEvent('ui-notify:sendNotify', { position = "top-right", message = "Message", type = "success", timeout = 5000 })
end, false)

RegisterCommand("sendtoast", function()
	TriggerEvent('ui-notify:sendNotify', {
		position = "top-right",
		message = "Message",
		timeout = 5000,
		toastMode = {
			title = "Title",
			message = "Message",
			action = "Action",
			button = {
				color = 'error',
				outlined = false,
				text = false,
				message = 'Close'
			}
		}
	})
end, false)

RegisterCommand("sendsnackbar", function()
	TriggerEvent('ui-notify:sendSnackbar', { position = "top-center", message = "Message", timeout = 5000 })
end, false)

local devUI = false
RegisterCommand("notify", function()
	ToggleNUIFocus()
	if Debug then
		devUI = not devUI
		SendNUIMessage({
			debug = devUI
		})
	end
end, false)
RegisterKeyMapping("notify", "Opens and closes the inventpory", "keyboard", "F2")
end

RegisterNetEvent('ui-notify:sendSnackbar')
AddEventHandler('ui-notify:sendSnackbar', function(data)
	SendNUIMessage({
		mode = 'snackbar',
		lightMode = data.lightMode,
		position = data.position or "top-center",
		message = data.message,
		timeout = data.timeout,
		settings = data.settings
	})
end)

RegisterNetEvent('ui-notify:sendNotify')
AddEventHandler('ui-notify:sendNotify', function(data)
	SendNUIMessage({
		mode = 'notification',
		lightMode = data.lightMode,
		position = data.position or "top-right",
		message = data.message,
		type = data.type,
		timeout = data.timeout,
		toastMode = data.toastMode,
		settings = data.settings
	})
end)