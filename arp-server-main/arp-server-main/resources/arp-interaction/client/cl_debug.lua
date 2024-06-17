local searchingTargetsDebug = false
local lastTargetEntityDebug = false

function StartDebugTargetting()
    if searchingTargetsDebug then return end
    searchingTargetsDebug = true
    local drawingCoords = false
    local tCoords = false
    Citizen.CreateThread(function()
        while searchingTargetsDebug do 
            local camPos = GetGameplayCamCoord()
            local targetCoords = s2w(camPos, 0, 0)
            tCoords = targetCoords
            local direction = targetCoords - camPos
            local fromCoords = camPos + (direction * 0.05)
            local toCoords = camPos + (direction * 300)
            local rayCast = StartShapeTestRay(fromCoords, toCoords, 26, ARP.GblPed, -1)
            local _, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayCast)
            local entityType = GetEntityType(entityHit)
            local hitting = hit == 1 and true or false
            if entityType == 0 then hitting = false end
            if not hitting and lastTargetEntityDebug then 
                lastTargetEntityDebug = false
                drawingCoords = false
            elseif hitting and lastTargetEntityDebug ~= entityHit then
                lastTargetEntityDebug = entityHit
                local entityModel = GetEntityModel(entityHit)
                local entityCoords = GetEntityCoords(entityHit)
                ARP.PrintTable({
                    entityHit = entityHit,
                    entityModel = entityModel,
                    entityType = entityType,
                    entityCoords = entityCoords,
                    surfaceNormal = surfaceNormal
                })
                UI:Send('clipboardCopy', entityCoords .. ' ' .. entityModel)
            end
            Citizen.Wait(300)
        end
    end)

    Citizen.CreateThread(function()
        while searchingTargetsDebug do 
            local pedCoords = GetEntityCoords(ARP.GblPed)
            local entityCoords = GetEntityCoords(lastTargetEntityDebug)
            local behind = GetOffsetFromEntityInWorldCoords(ARP.GblPed, 0, -2.0, -0.5)
            local forward = GetOffsetFromEntityInWorldCoords(ARP.GblPed, 0, 2.0, -0.5)
            local left = GetOffsetFromEntityInWorldCoords(ARP.GblPed, -2.0, 0.0, -0.5)
            local right = GetOffsetFromEntityInWorldCoords(ARP.GblPed, 2.0, 0.0, -0.5)

            DrawDebugOnScreen(0.8, 0.48, 0.4, 0.4, 0.30, "Frame Time: " .. GetFrameTime(), 255, 0, 0, 255)
            DrawDebugOnScreen(0.8, 0.50, 0.4, 0.4, 0.30, "Ped Heading: " .. GetEntityHeading(ARP.GblPed), 55, 155, 55, 255)
            DrawDebugOnScreen(0.8, 0.52, 0.4, 0.4, 0.30, "Ped Coords: " .. pedCoords, 55, 155, 55, 255)
            DrawDebugOnScreen(0.8, 0.54, 0.4, 0.4, 0.30, "Ped Attached Ent: " .. GetEntityAttachedTo(ARP.GblPed), 55, 155, 55, 255)
            DrawDebugOnScreen(0.8, 0.56, 0.4, 0.4, 0.30, "Ped Health: " .. GetEntityHealth(ARP.GblPed), 55, 155, 55, 255)
            DrawDebugOnScreen(0.8, 0.58, 0.4, 0.4, 0.30, "Ped Height Above Ground: " .. GetEntityHeightAboveGround(ARP.GblPed), 55, 155, 55, 255)
            DrawDebugOnScreen(0.8, 0.60, 0.4, 0.4, 0.30, "Ped Model: " .. GetEntityModel(ARP.GblPed), 55, 155, 55, 255)
            DrawDebugOnScreen(0.8, 0.62, 0.4, 0.4, 0.30, "Ped Speed: " .. GetEntitySpeed(ARP.GblPed), 55, 155, 55, 255)

            if lastTargetEntityDebug then 
                DrawDebugOnScreen(0.4, 0.5, 0.4, 0.4, 0.30, "Looking At Entity: " .. lastTargetEntityDebug, 155, 55, 55, 255)
                DrawDebugOnScreen(0.4, 0.52, 0.4, 0.4, 0.30, "Looking At Entity Heading: " .. GetEntityHeading(lastTargetEntityDebug), 155, 55, 55, 255)
                DrawDebugOnScreen(0.4, 0.54, 0.4, 0.4, 0.30, "Looking At Entity Coords: " .. GetEntityCoords(lastTargetEntityDebug), 155, 55, 55, 255)
                DrawDebugOnScreen(0.4, 0.56, 0.4, 0.4, 0.30, "Looking At Entity Model: " .. GetEntityModel(lastTargetEntityDebug), 155, 55, 55, 255)
                DrawDebugOnScreen(0.4, 0.58, 0.4, 0.4, 0.30, "Looking At Entity Type: " .. GetEntityType(lastTargetEntityDebug), 155, 55, 55, 255)
                DrawDebugOnScreen(0.4, 0.6, 0.4, 0.4, 0.30, "Looking At Entity Health: " .. GetEntityHealth(lastTargetEntityDebug), 155, 55, 55, 255)
                DrawDebugOnScreen(0.4, 0.62, 0.4, 0.4, 0.30, "Looking At Entity Speed: " .. GetEntitySpeed(lastTargetEntityDebug), 155, 55, 55, 255)
            end



            DrawLine(left, right, 0, 255, 0, 200)
            DrawLine(behind, forward, 0, 255, 0, 200)
            DrawLine(pedCoords, tCoords, 255, 0, 0, 200)
            if lastTargetEntityDebug then 
                DrawLine(pedCoords, entityCoords, 255, 0, 255, 200)
                DrawMarker(28, entityCoords.x, entityCoords.y, entityCoords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 255, 50, false, true, 2, nil, nil, false)
            end

            Citizen.Wait(5)
        end
    end)
end

function DrawDebugOnScreen(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.25, 0.25)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function StopDebugTargetting()
    searchingTargetsDebug = false
end