-- Config --
_garbageJob = {
    jobName = 'garbage', -- Job Name
    model = "s_m_y_garbage", gender = 'male', -- Ped Model / Gender (Male or Female)
    vehModel = "trash2", -- Vehicle Model
    pickJobPos = vector4(-355.068, -1546.154, 26.721, 265.257), -- Spawn Ped to Interact
    truckSpawnPos = { vector4(-332.715, -1566.251, 24.946, 56.866), vector4(-344.569, -1560.927, 25.230, 97.012), vector4(-368.491, -1524.099, 26.878, 176.288) } -- Spawn Truck (after having the job and using polyzones)
}

local testDumpCoords = vector3(114.83280181885, -1462.3127441406, 29.295083999634)

-- Coords used on GPS --
local dumpCoords = {
    {x = 114.83280181885, y = -1462.3127441406, z = 29.295083999634},
    {x = -6.0481648445129, y = -1566.2338867188, z = 29.209197998047},
    {x = -1.8858588933945, y = -1729.5538330078, z = 29.300233840942},
    {x = 159.09, y = -1816.69, z = 27.9},
    {x = 358.94696044922, y = -1805.0723876953, z = 28.966590881348},
    {x = 481.36560058594, y = -1274.8297119141, z = 29.64475440979},
    {x = 254.70010375977, y = -985.32482910156, z = 29.196590423584},
    {x = 240.08079528809, y = -826.91204833984, z = 30.018426895142},
    {x = 342.78308105469, y = -1036.4720458984, z = 29.194206237793},
    {x = 462.17517089844, y = -949.51434326172, z = 27.959424972534},
    {x = 317.53698730469, y = -737.95416259766, z = 29.278547286987},
    {x = 410.22503662109, y = -795.30517578125, z = 29.20943069458},
    {x = 398.36038208008, y = -716.35577392578, z = 29.282489776611},
    {x = 443.96984863281, y = -574.33978271484, z = 28.494501113892},
    {x = -1332.53, y = -1198.49, z = 4.62},
    {x = -45.443946838379, y = -191.32261657715, z = 52.161594390869},
    {x = -31.948055267334, y = -93.437454223633, z = 57.249073028564},
    {x = 283.10873413086, y = -164.81878662109, z = 60.060565948486},
    {x = 441.89678955078, y = 125.97653198242, z = 99.887702941895},
}

-- Check if is near --
local dumpProps = {
    "prop_dumpster_01a",
    "prop_dumpster_02a",
    "prop_dumpster_02b",
    "prop_dumpster_3a",
    "prop_dumpster_4a",
    "prop_dumpster_4b",
    "prop_skip_01a",
    "prop_skip_02a",
    "prop_skip_06a",
    "prop_skip_05a",
    "prop_skip_03",
    "prop_skip_10a"
}

-- Create Ped --
function CreatePedPos()
    local loaded = AwaitLoadModel(GetHashKey(_garbageJob.model))
    if not loaded then return end
    if gender == 'male' then
        genderNum = 4
    elseif gender == 'female' then 
        genderNum = 5
    end
    ped = CreatePed(genderNum, _garbageJob.model, _garbageJob.pickJobPos.x, _garbageJob.pickJobPos.y, _garbageJob.pickJobPos.z, _garbageJob.pickJobPos.w, false, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
end

-- Spawn Truck --
function SpawnTruckPos()
    local loaded = AwaitLoadModel(GetHashKey(_garbageJob.vehModel))
    if not loaded then return end
    local freeSpace = false
    for k, v in ipairs(_garbageJob.truckSpawnPos) do
        local vehInSpace = GetClosestVehicle(v.x, v.y, v.z, 5.0, 0, 71)
        if vehInSpace <= 0 or vehInSpace == nil then 
            freeSpace = k
            break
        end
    end
    if freeSpace then 
        print('spawn vehicle in space:', freeSpace)
        local spawnCoords = _garbageJob.truckSpawnPos[freeSpace]
        CreateVehicle(_garbageJob.vehModel, spawnCoords.x, spawnCoords.y, spawnCoords.z, spawnCoords.w, 1, 0)
        return true
    else
        print('all vehicle spaces taken')
        return false
    end
end

-- Check Distance To Pick Job--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300)
		local coords = GetEntityCoords(PlayerPedId())
        local dist = GetDistanceBetweenCoords(coords, _garbageJob.pickJobPos.x, _garbageJob.pickJobPos.y, _garbageJob.pickJobPos.z, true)
        if dist < 2.25 and not alreadyNotify then
            Components.Notify.Persistent:Set('s', 'Job Center', 'Talk to pick <span style="color: #b40000"><b>'.._garbageJob.jobName..'</b></span> job', 'mdi-briefcase-variant', false)
            alreadyNotify = true
        elseif dist > 2.25 and alreadyNotify then
            Components.Notify.Persistent:Clear()
            alreadyNotify = false
        else
            Citizen.Wait(800)
        end
	end
end)

-- Interact Confirm Dialog --
AddEventHandler('Interaction:KeyBindings:KeyDown', function(key)
    if key == 'interactionPrimary' and alreadyNotify and getPlayerJob() ~= 'unemployed' then -- TODO: Add only when looking
        Components.UI:SetFocus(true)
        Components.UI:Send('interactionDialog', {
            title = 'Attention',
            text = 'Picking this job will lead you to leave your actual job',
            actions = {
                { id = 'cancelEvent', color = 'red darken-4', text = 'Cancel' },
                { id = 'confirmEvent', color = 'green', text = 'Confirm' }
            }
        })
    elseif alreadyNotify then
        setPlayerJob(_garbageJob.jobName)
        Components.Notify:Success('Job Center', 'You have been hired', 'mdi-briefcase-variant')
    end
end)

AddEventHandler('UI:Client:DialogClick', function(data)
    if data then 
        if data.action == 'cancelEvent' then 
            Components.Notify:Error('Job Center', 'You know, we dont wanted you anyway', 'mdi-briefcase-variant')
        elseif data.action == 'confirmEvent' then 
            setPlayerJob(_garbageJob.jobName)
            Components.Notify:Success('Job Center', 'You have been hired', 'mdi-briefcase-variant')
        end
        Citizen.Wait(300)
        Components.UI:Send('interactionDialog', false)
        Components.UI:SetFocus(false)
        Components.UI:SetKeepInput(false)
    end
end)

-- OnComponentUpdate() --
function OnComponentUpdate(c)
    if not c or c == 'Blips' then
        DeleteEntity(ped)
        CreatePedPos()
        Components.Blips:Add('garbage', _garbageJob.pickJobPos, 'Garbage Job', 318, 0.8, 52, 2)
    end
end

-- Test Zone --
RegisterCommand("test:setjob", function(source , args, rawCommand)
	setPlayerJob(args[1])
    print(getPlayerJob())
end)

-- Spawn Truck When Have Job And Is Inside Polyzone --
local garbageZone = PolyZone:Create({
    vector2(-303.433, -1513.904),
    vector2(-372.800, -1518.581),
    vector2(-373.142, -1551.07),
    vector2(-361.119, -1577.376),
    vector2(-355.134, -1609.533)
}, {
    name="garbageZone",
    minZ=20.0,
    maxZ=62.0,
    debugGrid=false,
    gridDivisions=25
})

local insidegarbageZone = false
Citizen.CreateThread(function()
    while true do
        local plyPed = PlayerPedId()
        local coord = GetEntityCoords(plyPed)
        insidegarbageZone = garbageZone:isPointInside(coord)
        Citizen.Wait(2800)
        if insidegarbageZone and not alreadyNotified and getPlayerJob() == _garbageJob.jobName then
            Components.Notify.Persistent:Set('s', 'Garbage Job', 'Press <span style="color: #b40000"><b>E</b></span> to spawn a truck', 'mdi-briefcase-variant', false)
            alreadyNotified = true
        elseif not insidegarbageZone and alreadyNotified then
            Components.Notify.Persistent:Clear()
            alreadyNotified = false
        else
            Citizen.Wait(800)
        end
    end
end)

local jobStarted = false
Citizen.CreateThread(function()
    while true do
    Citizen.Wait(1)
        if IsControlJustPressed(0, 38) and alreadyNotified and getPlayerJob() == _garbageJob.jobName and not jobStarted then
            Components.Notify.Persistent:Clear()
            alreadyNotified = false
            if SpawnTruckPos() then
                Components.Notify:Success('Garbage Job', 'Truck spawned near you', 'mdi-briefcase-variant')
                jobStarted = true
                missionStart(testDumpCoords)
            end
        end
        if IsControlJustPressed(0, 38) and GetDistanceBetweenCoords(testDumpCoords, GetEntityCoords(GetPlayerPed(-1)),true) < 1.5 then
            print("picked prop")
        end
    end
end)