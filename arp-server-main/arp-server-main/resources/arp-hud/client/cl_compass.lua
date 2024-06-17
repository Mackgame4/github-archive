
function GetLocationData()
    if (HUD_SETTINGS and not HUD_SETTINGS.hideLocation) and VEHICLE_INSIDE then 
        local pedCoords = GetEntityCoords(ARP.GblPed)
        local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(pedCoords.x, pedCoords.y, pedCoords.z)
        return {
            street = GetStreetNameFromHashKey(currentStreetHash),
            intersection = GetStreetNameFromHashKey(intersectStreetHash),
            zone = GetLabelText(GetNameOfZone(pedCoords)),
            compass = getDirectionFromHeading(360.0 - GetEntityHeading(ARP.GblPed)),
            canShow = true,
        }
    else
        return {
            canShow = false
        }
    end
end