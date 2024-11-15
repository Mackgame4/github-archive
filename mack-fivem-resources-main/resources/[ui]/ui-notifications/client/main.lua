local isFocused = false
local debugMode = true

if debugMode then
	RegisterCommand("sendNotify", function()
		TriggerEvent("_notify:client:sendNotification", { position = "top-right", message = "Message", type = "success", timeout = 5000 })
	end, false)
	RegisterCommand("sendToastNotify", function()
		TriggerEvent("_notify:client:sendNotification", { position = "top-right", message = "Message", timeout = 5000, toastMode = {
			title = "Title",
			message = "Message",
			action = "Action",
			button = {
				color = 'error',
				outlined = false,
				text = false,
				message = 'Close'
			}
		}})
	end, false)
	RegisterCommand("sendSnackbar", function()
		TriggerEvent("_notify:client:sendSnackbar", { position = "top-center", message = "Message", timeout = 5000 })
	end, false)
end

function enableNui()
	isFocused = not isFocused
	SetNuiFocus(isFocused, isFocused)
	SetNuiFocusKeepInput(isFocused)
	if debugMode then
		SendNUIMessage({
			debug = true
		})
	end
end

-- Disable camera rotation when player is focused
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3)
		if isFocused then
			DisableAllControlActions(0)
		end
	end
end)

RegisterNetEvent("_notify:client:sendNotification")
AddEventHandler("_notify:client:sendNotification", function(data)
	SendNUIMessage({
		mode = 'notification',
		lightMode = data.lightMode,
		position = data.position,
		message = data.message,
		type = data.type,
		timeout = data.timeout,
		toastMode = data.toastMode,
		settings = data.settings
	})
end)

RegisterNetEvent("_notify:client:sendSnackbar")
AddEventHandler("_notify:client:sendSnackbar", function(data)
	SendNUIMessage({
		mode = 'snackbar',
		lightMode = data.lightMode,
		position = data.position,
		message = data.message,
		timeout = data.timeout,
		settings = data.settings
	})
end)

RegisterNetEvent('interactUI')
RegisterCommand("interactUI", function()
    enableNui()
end, false)

RegisterKeyMapping("interactUI", "Enables/disables UI interactions (mouse)", "keyboard", "F2")