VEHICLES = {
    GetSeatbeltWarningState = function(self) -- For the HUD if it should show the seatbelt warning
        if CHAR_LOADED and VEHICLE_INSIDE then 
            if IsVehicleClassACar(VEHICLE_INSIDE_CLASS) and not VEHICLE_BELT then 
                return true
            end
        end
        return false
    end,
}

AddEventHandler('ARP:Shared:Components:RegisterReady', function(resource)
    exports['arp-base']:RegisterComponent('Vehicles', VEHICLES)
end)