local stashSecondaryInventory = {
    type = 'stash',
    owner = ''
}

Citizen.CreateThread(function()
    while not ESXLoaded do
        Citizen.Wait(100)
    end
    for k, v in pairs(Config.Stash) do
        local marker = {
            name = k,
            type = v.markerType or 1,
            coords = v.coords,
            colour = v.markerColour or { r = 55, b = 255, g = 55 },
            size = v.size or vector3(0.5, 0.5, 1.0),
            action = function()
                stashSecondaryInventory.owner = k
                openInventory(stashSecondaryInventory)
                TriggerEvent('prp-inventory:removeCurrentWeapon')
				TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 7.0, 'Stash', 0.12)
            end,
            shouldDraw = function()
                if v.grade ~= nil then
                    if ESX.PlayerData.job.grade < v.grade then
                        return false
                    end
                end
                return ESX.PlayerData.job.name == v.job or v.job == 'all'
            end,
            msg = v.msg or 'Press ~INPUT_CONTEXT~ to open Stash',
			show3D = true
        }
        TriggerEvent('np_marker:registerMarker', marker)
    end
end)