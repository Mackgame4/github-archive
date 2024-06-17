ARP.GblPed = 0

Citizen.CreateThread(function()
    ARP.GblPed = PlayerPedId()
end)


function AwaitLoadModel(hash)
    if not IsModelValid(hash) then return false end
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(100)
    end
    return true
end

function LoadAndSetPlayerModel(hash)
    if AwaitLoadModel(hash) then 
        SetPlayerModel(PlayerId(), hash)
        SetModelAsNoLongerNeeded(hash)
    end
end

AddEventHandler('ARP:PlayerPedChanged', function(ped)
    ARP.GblPed = ped
end)

local entityEnumerator = {
    __gc = function(enum)
    if enum.destructor and enum.handle then
        enum.destructor(enum.handle)
    end
    enum.destructor = nil
    enum.handle = nil
    end
}
  
local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
        
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
        
        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next
        
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end
  
function EnumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end
  
function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end
  
function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end
  
function EnumeratePickups()
    return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end






-- Raycasting shit


function degToRad(deg)
    return (deg * math.pi) / 180.0
end

function rotationToDirection(rotation) 
    local z = degToRad(rotation.z)
    local x = degToRad(rotation.x)
    local num = math.abs(math.cos(x))
    return vector3((-math.sin(z) * num), (math.cos(z) * num), math.sin(x))
end

function w2s(position)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(position.x, position.y, position.z)
    if not onScreen then return nil end
    return vector3((_x - 0.5) * 2, (_y - 0.5) * 2, 0)
end

function s2w(camPos, relX, relY, custom)
    local camRot = GetGameplayCamRot(0)
    if custom then 
        camRot = custom
    end
    local camForward = rotationToDirection(camRot)
    local rotUp = camRot + vector3(10, 0, 0)
    local rotDown = camRot + vector3(-10, 0, 0)
    local rotLeft = camRot + vector3(0, 0, -10)
    local rotRight = camRot + vector3(0, 0, 10)
    local camRight = rotationToDirection(rotRight) - rotationToDirection(rotLeft)
    local camUp = rotationToDirection(rotUp) - rotationToDirection(rotDown)
    local rollRad = -degToRad(camRot.y)
    local camRightRoll = (camRight * math.cos(rollRad)) - (camUp * math.sin(rollRad))
    local camUpRoll = (camRight * math.sin(rollRad)) + (camUp * math.cos(rollRad))
    local point3D = ((camPos + (camForward * 10.0)) + camRightRoll) + camUpRoll
    local point2D = w2s(point3D)

    if point2D == nil then
        return camPos + (camForward * 10.0)
    end

    local point3DZero = camPos + (camForward * 10.0)
    local point3DZero = camPos + (camForward * 10.0)
    local point2DZero = w2s(point3DZero)

    if point2DZero == nil then
        return camPos + (camForward * 10.0)
    end

    local eps = 0.001

    if math.abs(point2D.x - point2DZero.x) < eps or math.abs(point2D.y - point2DZero.y) < eps then
        return camPos + (camForward * 10.0)
    end

    local scaleX = (relX - point2DZero.x) / (point2D.x - point2DZero.x)
    local scaleY = (relY - point2DZero.y) / (point2D.y - point2DZero.y)
    local point3Dret = ((camPos + camForward * 10.0) + (camRightRoll * scaleX)) + (camUpRoll * scaleY)

    return vector3(point3Dret.x, point3Dret.y, point3Dret.z)
end

function processCoordinates(x, y)
    local screenX, screenY = GetActiveScreenResolution()

    local relativeX = 1 - (x / screenX) * 1.0 * 2
    local relativeY = 1 - (y / screenY) * 1.0 * 2

    if relativeX > 0.0 then
        relativeX = -relativeX;
    else
        relativeX = math.abs(relativeX)
    end

    if relativeY > 0.0 then
        relativeY = -relativeY
    else
        relativeY = math.abs(relativeY)
    end

    return vector2(relativeX, relativeY)
end