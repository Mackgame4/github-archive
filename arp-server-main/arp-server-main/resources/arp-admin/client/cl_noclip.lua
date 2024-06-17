local noclipActive = false
local noclipEntity = false
local noclipMode = false

function ToggleNoClip()
    if noclipActive then 
        FreezeEntityPosition(noclipEntity, false);
        if not noclipMode then 
            SetEntityInvincible(noclipEntity, false);
            SetEntityCollision(noclipEntity, true, true);
            SetEntityVisible(noclipEntity, true, false);

            if noclipEntity ~= ARP.GblPed then
                SetEntityVisible(ARP.GblPed, true, false);
            end
        end
        noclipEntity = false
        exports['arp-freecam']:SetEnabled(false);

        noclipEntity = ARP.GblPed
        noclipActive = false
    else
        if not noclipMode then
            noclipEntity = ARP.GblPed 
            if IsPedInAnyVehicle(noclipEntity) then 
                noclipEntity = GetVehiclePedIsIn(noclipEntity, false)
            end
            if not NetworkHasControlOfEntity(noclipEntity) then
                noclipEntity = false;
                return
            end
            SetEntityInvincible(noclipEntity, true);
            FreezeEntityPosition(noclipEntity, true);
            SetEntityCollision(noclipEntity, false, false);
            SetEntityVisible(noclipEntity, false, false);

            if noclipEntity ~= ARP.GblPed then
                SetEntityVisible(ARP.GblPed, false, false);
            end
        else 
            FreezeEntityPosition(noclipEntity, true);
        end

        local entityCoords = GetEntityCoords(noclipEntity);
        exports['arp-freecam']:SetEnabled(true)
        exports['arp-freecam']:SetPosition(entityCoords.x, entityCoords.y, entityCoords.z)
        noclipActive = true
    end
end

RegisterNetEvent('FreeCam:Update')
AddEventHandler('FreeCam:Update', function()
    local position = exports['arp-freecam']:GetPosition()
    local rotation = exports['arp-freecam']:GetRotation()

    if noclipActive and noclipEntity and not noclipMode then 
        SetEntityCoordsNoOffset(noclipEntity, position, false, false, false)
        SetEntityRotation(noclipEntity, rotation, 0, true)
    end
end)

RegisterNetEvent('Admin:Client:NoClip')
AddEventHandler('Admin:Client:NoClip', function(mode)
    noclipMode = mode
    ToggleNoClip()
end)

RegisterNetEvent('Admin:Client:NoClipInfo')
AddEventHandler('Admin:Client:NoClipInfo', function()
    print(exports['arp-freecam']:GetPosition())
    print(exports['arp-freecam']:GetRotation())
end)

RegisterCommand('+noclip', function()
    if Components.Callbacks:Execute('Admin:ValidateStaff') then
        noclipMode = false
        ToggleNoClip()
    end
end, false)

RegisterKeyMapping('+noclip', '[Staff] NoClip', 'keyboard', "j")