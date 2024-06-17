local _zoomLevel = 1
local _zoomLevels = {
    --900,
    --1000,
    1100,
    1200,
    1300,
    1400
}

Citizen.CreateThread(function()
    SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(4, 15.3, 0.9, 0.08, 0.0, 0.0)
    SetRadarZoom(_zoomLevels[_zoomLevel])
end)

AddEventHandler('Interaction:KeyBindings:KeyDown', function(key, modifier)
    if key == 'HUDmapZoom' then 
        if _zoomLevel == #_zoomLevels then 
            _zoomLevel = 1
        else
            _zoomLevel = _zoomLevel + 1
        end
        SetRadarZoom(_zoomLevels[_zoomLevel])
    end
end)