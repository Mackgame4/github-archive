-- Fake Things --
local fakePlayerJob = 'unemployed'

function getPlayerJob()
    return fakePlayerJob
end

function setPlayerJob(job)
    if job ~= nil then
        fakePlayerJob = job
        return true
    else
        return false
    end
end

function missionStart(coordVector)
    arrived = false
    missionBlip = AddBlipForCoord(coordVector)
    SetBlipRoute(missionBlip, true)
    SetBlipRouteColour(missionBlip, 25)
    SetBlipColour(missionBlip, 25)
    Citizen.CreateThread(function()
        while not arrived do
            Citizen.Wait(5)
            local dist = GetDistanceBetweenCoords(coordVector, GetEntityCoords(GetPlayerPed(-1)),true)
            if dist < 50 then
                DrawMarker(20, coordVector + vector3(0.0,0.0,1.5), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 1.0, 0, 120, 0, 200, false, true, 2, false, false, false, false)
                if dist < 2 then
                    arrived = true
                    Citizen.Wait(1000)
                    SetBlipRoute(missionBlip, false)
                    RemoveBlip(missionBlip)
                    print(arrived)
                end
            else
                Citizen.Wait(1000)
            end
        end
    end)
end