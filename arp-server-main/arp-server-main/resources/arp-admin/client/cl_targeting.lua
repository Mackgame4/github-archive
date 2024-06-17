local inVehicle = false

function RegisterTargetingCallback()
    Components.Callbacks:Register('Admin:Client:GetEntityLookingAt', function(cb, forVehicle)
        if forVehicle and inVehicle then 
            cb({ entity = VehToNet(inVehicle), type = 2 })
            return
        end

        local camPos = GetGameplayCamCoord()
        local targetCoords = s2w(camPos, 0, 0)
        local direction = targetCoords - camPos
        local fromCoords = camPos + (direction * 0.05)
        local toCoords = camPos + (direction * 300)
        local rayCast = StartShapeTestRay(fromCoords, toCoords, 26, ARP.GblPed, -1)
        local _, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayCast)
        local entityType = GetEntityType(entityHit)
        if hit and entityHit and entityType >= 1 and NetworkGetEntityIsNetworked(entityHit) then 
            if entityType == 1 then -- peds
                cb({ entity = PedToNet(entityHit), type = 1 })
            elseif entityType == 2 then -- vehicles
                cb({ entity = VehToNet(entityHit), type = 2 })
            elseif entityType == 3 then -- object
                cb({ entity = ObjToNet(entityHit), type = 3 })
            end
        else
            cb(false)
        end
    end)

    Components.Callbacks:Register('Admin:Client:GetVehicleSpawningData', function(cb, hash)
        if IsModelValid(hash) and IsModelAVehicle(hash) then 
            local pedCoords = GetEntityCoords(ARP.GblPed)
            local camPos = GetGameplayCamCoord()
            local targetCoords = s2w(camPos, 0, 0)
            local direction = targetCoords - camPos
            local fromCoords = camPos + (direction * 0.05)
            local toCoords = camPos + (direction * 300)
            local rayCast = StartShapeTestRay(fromCoords, toCoords, 1, ARP.GblPed, -1)
            local _, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayCast)
            local dist = #(endCoords - pedCoords)
            if dist <= 20.0 and hit then 
                cb(endCoords)
            else 
                cb(false)
            end
        else
            cb(false)
        end
    end)
end

AddEventHandler('Vehicles:Client:EnterVeh', function(veh)
    inVehicle = veh
end)

AddEventHandler('Vehicles:Client:ExitVeh', function()
    inVehicle = false
end)