ESX.Fleets = {

}

local FleetPlates = {}

local NumberCharset = {}
local Charset = {}

for i = 48, 57 do
    table.insert(NumberCharset, string.char(i))
end

for i = 65, 90 do
    table.insert(Charset, string.char(i))
end
for i = 97, 122 do
    table.insert(Charset, string.char(i))
end

--[[
    {
        {
            model = "model"
            label = "Label"
            price = 12000
            grade = 2
        }
    }
]]--

local afterLoad = {}

function RegisterFleet(job, fleet)
    if not job then
        Logger.error("No Job Specified for Fleet Registration")
        return
    end

    if not fleet then
        Logger.error(("No Fleet Config specified for Fleet Registration for %s"):format(job))
        return
    end

    if not fleet.location or not fleet.heading then
        Logger.error(("No Fleet Location or Heading specified for Fleet Registration for %s"):format(job))
        return
    end

    if not fleet.spawns or #fleet.spawns == 0 then
        Logger.error(("No Fleet Spawns specified for Fleet Registration for %s"):format(job))
        return
    end

    for k, v in ipairs(fleet.vehicles or {}) do
        if not v.model then
            Logger.error(("No Model Specified in %s for %s at Fleet Registration"):format(json.encode(v), job))
            return
        end

        if not v.label then
            Logger.error(("No Label Specified in %s for %s at Fleet Registration"):format(json.encode(v), job))
            return
        end

        if not v.price then
            Logger.warn(("No Price Specified for % for %s at Fleet Registration. Defaulting to 0"):format(v.label, job))
            fleet[k].price = 0
        end

        if not v.level then
            Logger.warn(("No Grade Level Specified for % for %s at Fleet Registration, Defaulting to 0"):format(v.label, job))
            fleet[k].level = 0
        end
    end

    Citizen.CreateThread(function()
        if exports.mongodb.isConnected then
            LoadOwnedVehicles(job)
        else
            table.insert(afterLoad, job)
        end
    end)

    local mechanic = {
        name = ("%s:mechanic"):format(job),
        render = {
            location = fleet.location,
            heading = fleet.heading,
            distance = 50,
            model = "IG_Old_Man2",
            freeze = true,
            blockevents = true
        },
        interact = {
            options = {
                {
                    job = job,
                    event = "_core:Client:Fleet:SelectVehicle",
                    icon = "fas fa-car-side",
                    label = "Select Fleet Vehicle"
                },
                {
                    job = job,
                    event = "_core:Client:Fleet:TakeOutVehicle",
                    icon = "fas fa-car",
                    label = "Take Out Fleet Vehicle"
                },
                {
                    job = job,
                    boss = true,
                    event = "_core:Client:Fleet:OpenFleetManage",
                    icon = "fas fa-gear",
                    label = "Manage Fleet",
                },
            },
            distance = 1.5
        }
    }

    RegisterNPC(mechanic)

    ESX.Fleets[job] = fleet
end

exports('RegisterFleet', RegisterFleet)

function GetFleetAvailableVehicles(job)
    return ESX.Fleets[job].vehicles
end

function GetFleetVehicles(job)
    return ESX.Fleets[job].owned
end

function LoadOwnedVehicles(job)
    local success, data = table.unpack(exports.mongodb:findOne({
        collection = "fleets",
        query = {
            job = job
        }
    }))

    data = data[1]

    if not success then
        Logger.error(("Loading Owned Fleet Vehicles Failed for %s"):format(job))
        return
    end

    if not data then
        Logger.warn(("No Owned vehicles for %s"):format(job))
    else
        ESX.Fleets[job].owned = {}
        ESX.Fleets[job].selected = {}
        local count = 0
        for k, v in pairs(data.owned) do
            count = count + 1
            local vehicle = table.clone(ESX.Fleets[job].vehicles[v.model])
            vehicle.plate = v.plate
            vehicle.selected = v.selected
            FleetPlates[v.plate] = true
            ESX.Fleets[job].owned[v.plate] = vehicle
            if v.selected then
                ESX.Fleets[job].selected[v.selected] = v.plate
            end
        end
        Logger.info(("Loaded %s vehicles for %s"):format(count, job))
    end
end

RegisterNetEvent('onDatabaseConnect', function()
    for k, job in ipairs(afterLoad) do
        LoadOwnedVehicles(job)
        afterLoad[k] = nil
    end
end)

RegisterNetEvent('_core:Client:Fleet:SelectVehicle', function(plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.job.name
    local level = xPlayer.job.level
    local vehicle = ESX.Fleets[job].owned[plate]
    if ESX.Fleets[job].owned[plate] and level >= vehicle.level then
        if not ESX.Fleets[job].selected then
            ESX.Fleets[job].selected = {}
        end
        exports.mongodb:updateOne({
            collection = "fleets",
            query = {
                job = job
            },
            update = {
                ['$set'] = {
                    ['owned.' .. plate .. '.selected'] = xPlayer.identifier
                }
            }
        })
        ESX.Fleets[job].owned[plate].selected = xPlayer.identifier
        ESX.Fleets[job].selected[xPlayer.identifier] = plate
        xPlayer.showNotification(('Selected Vehicle %s'):format(plate))
    else
        xPlayer.showNotification(('Failed to select Vehicle %s'):format(plate))
    end
end)

ESX.RegisterServerCallback('_core:Client:Fleet:GetSelectedVehicle', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.job.name
    local plate = ESX.Fleets[job].selected[xPlayer.identifier]
    cb(plate and ESX.Fleets[job].owned[plate] or nil)
end)

ESX.RegisterServerCallback('_core:Client:Fleet:GetVehicles', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.job.name
    cb(GetFleetVehicles(job))
end)

ESX.RegisterServerCallback('_core:Client:Fleet:GetAvailableVehicles', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.job.name
    cb(GetFleetAvailableVehicles(job))
end)

RegisterNetEvent('_core:Client:Fleet:BuyVehicle', function(model)
    if not model then
        Logger.error("No Model Specified for buying")
        return
    end

    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    --TODO TAKE MONEY FROM FUNDS
    local job = xPlayer.job.name
    local fleetVehicle = table.clone(ESX.Fleets[job].vehicles[model])
    local price = fleetVehicle.price
    Logger.info('Taking $' .. price)

    local plate = GenerateFleetPlate()

    local vehicle = {
        plate = plate,
        model = model
    }
    if not ESX.Fleets[job].owned then
        ESX.Fleets[job].owned = {}
        exports.mongodb:insertOne({
            collection = "fleets",
            document = {
                job = job,
                owned = {
                    [plate] = vehicle
                }
            }
        })
    else
        exports.mongodb:updateOne({
            collection = "fleets",
            query = {
                job = job
            },
            update = { ['$set'] = {
                ['owned.' .. plate] = vehicle
            } }
        })
    end

    local ownedVehicle = fleetVehicle
    ownedVehicle.plate = plate
    ESX.Fleets[job].owned[plate] = ownedVehicle

    xPlayer.showNotification(("Bought Vehicle with Plate %s for $%s"):format(plate, price))
end)

RegisterNetEvent('_core:Client:Fleet:SellVehicle', function(plate)
    if not plate then
        Logger.error("No Plate Specified for selling")
        return
    end
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    --TODO TAKE MONEY FROM FUNDS
    local job = xPlayer.job.name
    local fleetVehicle = ESX.Fleets[job].owned[plate]
    local price = fleetVehicle.price * 0.7
    Logger.info(("Giving back $%s"):format(price))

    exports.mongodb:updateOne({
        collection = "fleets",
        query = {
            job = job
        },
        update = { ['$unset'] = {
            ['owned.' .. plate] = 1
        } }
    })

    ESX.Fleets[job].owned[plate] = nil
    for k, v in pairs(ESX.Fleets[job].selected or {}) do
        if v == plate then
            ESX.Fleets[job].selected[k] = nil
        end
    end
end)

ESX.RegisterServerCallback('_core:Server:Fleet:TakeOutVehicle', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.job.name
    local selectedPlate = ESX.Fleets[job].selected[xPlayer.identifier]
    if selectedPlate then
        local selectedVehicle = ESX.Fleets[job].owned[selectedPlate]
        if not selectedVehicle.out then
            local spawns = ESX.Fleets[job].spawns
            local data = {
                model = selectedVehicle.model,
                spawns = spawns,
                plate = selectedVehicle.plate
            }
            ESX.Fleets[job].owned[selectedPlate].out = true
            return cb(data)
        end
    end
    cb()
end)

function GetRandomNumber(length)
    Citizen.Wait(0)
    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
    else
        return ''
    end
end

function GetRandomLetter(length)
    Citizen.Wait(0)
    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
    else
        return ''
    end
end

function GenerateFleetPlate()
    local generatedPlate

    while true do
        Citizen.Wait(2)
        math.randomseed(GetGameTimer())
        generatedPlate = string.upper('F-' .. GetRandomLetter(3) .. '-' .. GetRandomNumber(3) .. '-LS')
        Logger.info("Generated Fleet Plate: " .. tostring(generatedPlate))
        if not FleetPlates[generatedPlate] then
            FleetPlates[generatedPlate] = true
            return generatedPlate
        end
        Logger.warn("Generated Plate is taken. Retrying...")
    end

    return generatedPlate
end


