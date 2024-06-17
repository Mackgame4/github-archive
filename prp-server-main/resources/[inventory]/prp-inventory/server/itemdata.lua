itemData = {}
itemInfo = {}

AddEventHandler("onDatabaseConnect", function()
    itemData = {}
    local success, results = table.unpack(exports.mongodb:find({ collection = "itemdata", query = {} }))
    for k, v in pairs(results) do
        itemData[v.name] = v
    end
    local success, data = table.unpack(exports.mongodb:find({ collection = "items", query = {} }))
    for k, v in pairs(data) do
        itemInfo[v.name] = v
    end
end)

function inventoryItem(name)
    return itemInfo[name]
end

function getItemDataProperty(name, property)
    if itemData[name] and itemData[name][property] then
        return itemData[name][property]
    else
        return nil
    end
end