local isFocused = false

-- TODO: Tablet Item
RegisterCommand('mdt', function()
	isFocused = not isFocused
	print(isFocused)
	SetNuiFocus(isFocused, isFocused)
	SendNUIMessage({
		show = isFocused
	})
end, false)