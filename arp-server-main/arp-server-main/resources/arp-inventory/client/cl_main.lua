InventoryOpen = false
Callbacks = {}
UI = {}
LocalInventory = {} -- this is only cached for keybinds

local ItemData = {}
local awaitingUpdate = false

RegisterNetEvent('Inventory:Client:SetItemData')
AddEventHandler('Inventory:Client:SetItemData', function(data)
    UI:SendUI('inventorySetItemData', data)
end)

RegisterNetEvent('Inventory:Client:UpdateInventory')
AddEventHandler('Inventory:Client:UpdateInventory', function(data)
    print('updated inventory', data.type, data.identifier)
    data.items['cunt'] = true
    if data.type == 'character' then 
        local myChar = exports['arp-base']:GetCharacterData()
        if not myChar then return end
        if myChar.CID == tonumber(data.identifier) then 
            LocalInventory = data 
            if InventoryOpen then 
                UI:SendUI('inventoryUpdateLocal', LocalInventory)
            end
        else
            UI:SendUI('inventoryUpdateRemote', data)
        end
    else
        UI:SendUI('inventoryUpdateRemote', data)
    end
end)

RegisterNetEvent('Inventory:Client:ItemNotification')
AddEventHandler('Inventory:Client:ItemNotification', function(itemData)
    if itemData.item and itemData.count then 
        UI:SendUI('inventoryItemNotif', itemData)
    end
end)

function OpenInventory()
    local success, characterInventory, remoteInventory = Callbacks:Execute('Inventory:Open')
    if success then 
        LocalInventory = characterInventory
        OpenInventoryUI(characterInventory, remoteInventory)
    end
end

function CloseInventory(forced)
    if InventoryOpen and not awaitingUpdate or forced then 
        InventoryOpen = false
        UI:SendUI('inventoryClose', {})
        UI:SetUIFocus(false)
        TriggerServerEvent('Inventory:Server:Close')
    end
end

function MoveInventoryItem(data)
    if InventoryOpen and data then
        awaitingUpdate = true
        Citizen.Wait(100 + (ARP.RandomNumber(2, 5) * 100))
        TriggerServerEvent('Inventory:Server:MoveItem', data.from, data.fromSlot, data.target, data.targetSlot, data.moveAmount)
        Citizen.Wait(1000)
        awaitingUpdate = false
    end
end

function UseInventoryItem(slot)
    print('use item', slot)
    TriggerServerEvent('Inventory:Server:UseItem', slot)
end

function OpenInventoryUI(localInv, remoteInv)
    if InventoryOpen then 
        CloseInventory(true)
        Citizen.Wait(500)
    end
    InventoryOpen = true
    localInv.items['cunt'] = true
    if remoteInv and remoteInv.items then 
        remoteInv.items['cunt'] = true
    end
    UI:SendUI('inventoryOpen', {
        localInventory = localInv,
        remoteInventory = remoteInv
    })
    UI:SetUIFocus(true)
end

RegisterNetEvent('Inventory:Client:Open')
AddEventHandler('Inventory:Client:Open', OpenInventoryUI)

Citizen.CreateThread(function()
    Callbacks = exports['arp-base']:Component('Callbacks')
    UI = exports['arp-ui']
    UI:RegisterUICallback('closeInventory', function(data, cb)
        cb({ success = true })
        CloseInventory()
    end)

    UI:RegisterUICallback('inventoryMoveItems', function(data, cb)
        print('MOVE ITEM YEAH', ARP.FormatTable(data))
        cb({ success = true })
        MoveInventoryItem(data)
    end)

    UI:RegisterUICallback('inventoryUseItem', function(data, cb)
        cb({ success = true })
        UseInventoryItem(data)
    end)
end)


RegisterCommand('+openInventory', OpenInventory)
RegisterKeyMapping('+openInventory', 'Open Inventory', 'keyboard', 'f2')