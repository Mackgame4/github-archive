
ANIMATE.Features = {
    SetWalk = function(self, walk, label)
        if walk == 'reset' then
            ResetPedMovementClipset(ARP.GblPed, 0.0)
            walkStyle = walk
        else
            ReqAnimSet(walk)
            SetPedMovementClipset(ARP.GblPed, walk, 0.2)
            RemoveAnimSet(walk)
            walkStyle = walk
        end
    end,
    SetExpression = function(self, expression, label)
        if expression == 'reset' then
            ClearFacialIdleAnimOverride(ARP.GblPed)
            facialExpression = expression

        else
            SetFacialIdleAnimOverride(ARP.GblPed, expression, 0)
            facialExpression = expression

        end
    end,
    RequestFeaturesUpdate = function(self)
        if walkStyle ~= 'default' then
            ReqAnimSet(walkStyle)
            SetPedMovementClipset(ARP.GblPed, walkStyle, 0.6)
            RemoveAnimSet(walkStyle)
        end
        if facialExpression ~= 'default' then
            SetFacialIdleAnimOverride(ARP.GblPed, facialExpression, 0)
        end
    end,
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(8000)
        if CHAR_LOADED then
            --if not Damage:IsLimping() and not crouched then
            Components.Animate.Features:RequestFeaturesUpdate()
            --end
        end
    end
end)

RegisterNetEvent('Animate:Client:RecieveAnimFeatures')
AddEventHandler('Animate:Client:RecieveAnimFeatures', function(data)
    if data and data.walk and data.expression then
        walkStyle, facialExpression = data.walk, data.expression
        Components.Animate.Features:RequestFeaturesUpdate()
    end
end)