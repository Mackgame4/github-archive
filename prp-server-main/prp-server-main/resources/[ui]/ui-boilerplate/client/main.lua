local isFocused = false

RegisterCommand('openUI', function()
	isFocused = not isFocused
	SetNuiFocus(isFocused, isFocused)
end, false)