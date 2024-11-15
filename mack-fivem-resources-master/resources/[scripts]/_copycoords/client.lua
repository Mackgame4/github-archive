
RegisterCommand('copycoords', function(source, args, rawCommand)
	local coords = GetEntityCoords(PlayerPedId())
	SendNUIMessage({
		--coords = '{\nx = '..coords.x .. ',\ny = '..coords.y..',\nz = '..coords.z .. ',\nh = '..heading .. '\n}'
		coords = 'vector3(' .. coords.x .. ', ' ..coords.y .. ', ' .. coords.z .. ')'
	})
end)


RegisterCommand('copyheading', function(source, args, rawCommand)
	local heading = GetEntityHeading(PlayerPedId())
	SendNUIMessage({
		--coords = '{\nx = '..coords.x .. ',\ny = '..coords.y..',\nz = '..coords.z .. ',\nh = '..heading .. '\n}'
		coords = heading
	})
end)