esx = nil

TriggerEvent('CLYDOsx:getSharedObject', function(obj) esx = obj end)

AddEventHandler("onDatabaseConnect", function()
    Wait(100)
    TriggerEvent('prp-inventory:RegisterInventory', {
        name = 'shop',
        label = 'Shop',
        slots = 40,
        weight = '1000',
        getInventory = function(identifier, cb)
            getShopInventory(identifier, cb)
        end,
        saveInventory = function(identifier, inventory)

        end,
        applyToInventory = function(identifier, f)
            getShopInventory(identifier, f)
        end,
        getDisplayInventory = function(identifier, cb, source)
            getShopDisplayInventory(identifier, cb, source)
        end
    })
end)


function getShopInventory(identifier, cb)
    local shop = Config.Shops[identifier]
    local items = {}
    for k, v in pairs(shop.items) do
        v.usable = false
        items[tostring(k)] = v
    end
    cb(items)
end

function getShopDisplayInventory(identifier, cb, source)
    local player = ESX.GetPlayerFromId(source)
    InvType['shop'].getInventory(identifier, function(inventory)
        local itemsObject = {}

        for k, v in pairs(inventory) do
            local ESXItem = inventoryItem(v.name)
            local item = createDisplayItemShop(v, ESXItem, tonumber(k), v.price)
            local addItem = true

            if v.grade ~= nil then
                if player.job.grade < v.grade then
                    addItem = false
                end
            end

            if addItem then
                table.insert(itemsObject, item)
            end
        end

        local inv = {
            invId = identifier,
            invTier = InvType['shop'],
            inventory = itemsObject,
        }
        cb(inv)
    end)
end

function getGunshopInventory(identifier, cb)
    local gunshop = Config.gunshop[identifier]
    local items = {}
    for k, v in pairs(gunshop.items) do
        v.usable = false
        if isWeapon(v.name) then
            v.metadata = {}
            v.staticMeta = {}
            v.staticMeta.serial = RegisterSerial(9) 
        end
        items[tostring(k)] = v
    end
    cb(items)
end

function getGunshopDisplayInventory(identifier, cb, source)
    local player = ESX.GetPlayerFromId(source)
    InvType['gunshop'].getInventory(identifier, function(inventory)
        local itemsObject = {}

        for k, v in pairs(inventory) do
            local ESXItem = inventoryItem(v.name)
            local item = createDisplayItemGunshop(v, ESXItem, tonumber(k), v.price)
            local addItem = true

            if v.grade ~= nil then
                if player.job.grade < v.grade then
                    addItem = false
                end
            end

            if addItem then
                table.insert(itemsObject, item)
            end
        end

        local inv = {
            invId = identifier,
            invTier = InvType['gunshop'],
            inventory = itemsObject,
        }
        cb(inv)
    end)
end