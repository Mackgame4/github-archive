
RegisterNUICallback('UseItem', function(data)
    TriggerServerEvent("prp-inventory:itemUse", data.item.id)
end)

isHotKeyCoolDown = false
local tempDisableHotkeys = false
local keys = { 
    157, 158, 160, 164
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        BlockWeaponWheelThisFrame()
        HideHudComponentThisFrame(19)
        HideHudComponentThisFrame(20)
        HideHudComponentThisFrame(17)
        DisableControlAction(0, 37, true) --Disable Tab
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if not tempDisableHotkeys then
            for k, v in pairs(keys) do
                if IsDisabledControlJustReleased(0, v) then
                    UseItem(k)
                    Wait(1000)
                end
            end
	        if IsDisabledControlJustReleased(0, 37) then
	            TriggerServerEvent('prp-inventory:GetItemsInSlotsDisplay')
	        end
        end
    end
end)

RegisterNetEvent("disc-inventoryhud:DisableHotKeys")
AddEventHandler("disc-inventoryhud:DisableHotKeys", function(boolean)
    tempDisableHotkeys = boolean
end)

RegisterNetEvent('prp-inventory:ShowSlotItems')
AddEventHandler('prp-inventory:ShowSlotItems', function(items)
    SendNUIMessage({
        action = 'showActionBar',
        items = items
    })
end)

function UseItem(slot)
    TriggerServerEvent('prp-inventory:UseItemSlot', slot)
end



RegisterNetEvent('prp-inventory:showItemUse')
AddEventHandler('prp-inventory:showItemUse', function(items)
    TriggerEvent('prp-inventory:checkWeapons', items)
    local data = {}
    for k, v in pairs(items) do
        table.insert(data, {
            item = {
                label = v.label,
                itemId = v.id
            },
            qty = v.qty,
            message = v.msg
        })
    end
    SendNUIMessage({
        action = 'itemUsed',
        alerts = data
    })
end)

RegisterNetEvent('prp-inventory:handleUsedItem')
AddEventHandler('prp-inventory:handleUsedItem', function(name, item)
    TriggerEvent('prp-inventory:tempDisableAnim')
    local isWeapon = false

    local data = { id = item.name, label = item.label, qty = 1, msg = 'Used' }

    for k,v in pairs(Config.Weapons) do
        if name == v.item then
            isWeapon = true
            break
        end
    end

    if isWeapon then        
        local rerval, weaponHash = GetCurrentPedWeapon(PlayerPedId())
        if weaponHash == GetHashKey('WEAPON_UNARMED') then
            data.msg = 'Equip'
        else
            data.msg = 'Holster'
        end
    end

    TriggerEvent('prp-inventory:showItemUse', { data })
end)


 