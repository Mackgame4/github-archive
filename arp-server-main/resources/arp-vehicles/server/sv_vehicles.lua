ActiveOwnedVehicles = {}
local CREATE_AUTOMOBILE = `CREATE_AUTOMOBILE`

function CreateAutomobile(model, coords, heading)
    local veh = Citizen.InvokeNative(CREATE_AUTOMOBILE, model, coords.x, coords.y, coords.z)
    if DoesEntityExist(veh) then
        SetEntityHeading(veh, heading + 0.0)
        return veh
    end
    return nil
end

VEHICLES = {}

--[[
POPTYPE_UNKNOWN = 0, 
POPTYPE_RANDOM_PERMANENT, 1
POPTYPE_RANDOM_PARKED, 2
POPTYPE_RANDOM_PATROL, 3
POPTYPE_RANDOM_SCENARIO, 4
POPTYPE_RANDOM_AMBIENT, 5
POPTYPE_PERMANENT, 6
POPTYPE_MISSION, 7
POPTYPE_REPLAY, 8
POPTYPE_CACHE, 9
POPTYPE_TOOL 10 
]]

AddEventHandler('entityCreating', function(entity)
    if GetEntityType(entity) == 2 then -- its a vehicle
        local model = GetEntityModel(entity) --ARP.GetPositionInOrderedTable(_blockedVehicles, model)
        if ARP.GetPositionInOrderedTable(_blockedVehicles, model) then 
            CancelEvent()
        end
    end
end)

AddEventHandler('entityCreated', function(entity)
    if not DoesEntityExist(entity) or not Components.Vehicles then return end
    local entityType = GetEntityType(entity)
    local populationType = GetEntityPopulationType(entity)
    if entityType == 2 and (populationType == 2 or populationType == 5) then 
        local veh = Entity(entity)
        veh.state.owned = false
        veh.state.locked = false
        veh.state.hotwired = false
        veh.state.keysFound = false
        if not veh.state.VIN then 
            veh.state.VIN = Components.Vehicles.VIN:GenerateAI(entity)
        end

        local vehicleParked = populationType == 2
        local lockedChance = vehicleParked and 75 or 45
        if ARP.RandomNumber(1, 100) <= lockedChance then 
            veh.state.locked = true
            SetVehicleDoorsLocked(entity, 2)
        else
            SetVehicleDoorsLocked(entity, 1)
        end
    end
end)

local ownerTypes = {
    [1] = 'personal',
    [2] = 'organization'
}

local storageTypes = {
    [1] = 'public',
    [2] = 'private'
}

VEHICLES.Owned = {
    New = function(self, ownerType, ownerID, model)
        if ownerTypes[ownerType] and IsOwnerIdentifierAvailable(ownerID) then
            local generatedVIN = Components.Vehicles.VIN:GenerateOwned()

            local newVeh = {
                VIN = generatedVIN,
                PlateRegistered = generatedPlate,
                PlateCurrent = generatedPlate,
                Owner = {
                    Type = ownerType,
                    Id = ownerID,
                },
                Vehicle = _vehData[model].hash,
                Stored = {
                    Type = 1,
                    Id = '1'
                },
                Fuel = 100,
                Impounded = false,
                Appearance = false, -- ? Defaults are set on its first spawn
                Performance = false, -- ? same as ^
                Damage = {}
            }

            local inserted = Components.DB:InsertOne('vehicles', newVeh)
            if inserted.success and #inserted.inserted >= 1 then 
                return true
            end
        end
        return false
    end,
    Out = function(self, src, vin, coords, heading) -- Pull a vehicle out
        if not Components.Vehicles.Owned:Get(vin) and coords then 
            local foundVeh = FetchVehicleFromDB(vin)
            if not foundVeh or not foundVeh.Vehicle then return false end
            local veh = CreateAutomobile(foundVeh.Vehicle, coords, heading)
            if veh then 
                foundVeh.Entity = veh
                local vStore = Components.Store:Create('Vehicles', vin, foundVeh)
                ActiveOwnedVehicles[vin] = vStore
                local vehEntity = Entity(veh)
                vehEntity.state.owned = true
                vehEntity.state.VIN = vin
                vehEntity.state.locked = true
                vehEntity.state.hotwired = false
                vehEntity.state.keysFound = true
                vehEntity.state.damage = vStore:GetData('Damage')
                vehEntity.state.fuel = vStore:GetData('Fuel')
                
                local appearanceData = vStore:GetData('Appearance')
                local performanceData = vStore:GetData('Performance')

                Citizen.Wait(500)

                SetVehicleDoorsLocked(veh, 2)
                
                if not appearanceData or not performanceData then
                    Citizen.Wait(1500)
                    local defaultAppearance = GetInitialAppearanceData(veh)
                    local defaultPerformance = GetInitialPerformanceData(veh)
                    vStore:SetData('Appearance', defaultAppearance)
                    vStore:SetData('Performance', defaultPerformance)
                    SaveVehicle(vin)
                end

                TriggerClientEvent('Vehicles:Client:ApplyToVehicle', src, NetworkGetNetworkIdFromEntity(veh), vStore:GetData('Appearance'), vStore:GetData('Performance'), vStore:GetData('Damage'))

                SetVehicleNumberPlateText(veh, vStore:GetData('PlateRegistered'))
                SetVehicleDoorsLocked(veh, 2)

                AddVehicleKeysToChar(src, vin)
                TriggerClientEvent('Client:Notify', src, 'success', 'Vehicle recieved from storage', false, 'mdi-garage-variant')
                return true
            end
        end
        return false
    end,
    Store = function(self, vin, storeType, storeId) -- Store a vehicle that is already out
        local vehStore = Components.Vehicles.Owned:Get(vin)
        if vehStore then 
            local vehEntityId = vehStore:GetData('Entity')

            if DoesEntityExist(vehEntityId) then 
                local veh = Entity(vehEntityId)
                local damageData = veh.state.damage ~= nil and veh.state.damage or {}
                local engineHealth = GetVehicleEngineHealth(vehEntityId)
                if veh.state.fuel and type(veh.state.fuel) == 'number' then 
                    vehStore:SetData('Fuel', veh.state.fuel)
                end

                vehStore:SetData('Damage', {
                    engineHealth = engineHealth,
                    dirtLevel = damageData.dirtLevel,
                    bodyHealth = damageData.bodyHealth,
                    missingDoors = damageData.missingDoors,
                    burstTyres = damageData.burstTyres
                })

                if storeType and storeId then -- otherwise go to last
                    vehStore:SetData('Stored', {
                        Type = storeType,
                        Id = storeId
                    })
                end


                -- Save First
                SaveVehicle(vin)
                DeleteEntity(vehEntityId)
            end

            Components.Store:Delete('Vehicles', vin)
            ActiveOwnedVehicles[vin] = nil
            collectgarbage()
            return true
        else
            return false
        end
    end,
    Impound = function(self, vin)
        
    end,
    Get = function(self, vin) -- Get Vehicle that is already out
        if ActiveOwnedVehicles[vin] then 
            return ActiveOwnedVehicles[vin]
        end
        return false
    end
}

VEHICLES.Temp = {
    Spawn = function(self, src, model, coords, heading, appearance, performance, fuel) 
        if not fuel then fuel = 100 end
        local vin = Components.Vehicles.VIN:GenerateOwned()
        local generatedPlate = Components.Vehicles.Plates:GenerateOwned()
        local veh = CreateAutomobile(model, coords, heading)
        if veh then 
            local vehEntity = Entity(veh)
            vehEntity.state.owned = false
            vehEntity.state.VIN = vin
            vehEntity.state.locked = true
            vehEntity.state.hotwired = false
            vehEntity.state.keysFound = true
            vehEntity.state.fuel = fuel
            Citizen.Wait(500)
            
            if appearance or performance then 
                TriggerClientEvent('Vehicles:Client:ApplyToVehicle', src, NetworkGetNetworkIdFromEntity(veh), appearance, performance, false)
            end
            
            SetVehicleDoorsLocked(veh, 2)
            SetVehicleNumberPlateText(veh, generatedPlate)

            AddVehicleKeysToChar(src, vin)
            return true
        end
        return false
    end
}

RegisterNetEvent('Vehicles:Server:RequestSpawnVehicle')
AddEventHandler('Vehicles:Server:RequestSpawnVehicle', function(vin, spawn)
    local src = source
    Components.Vehicles.Owned:Out(src, vin, spawn.xyz, spawn.w)
end)


function FetchVehicleFromDB(vin)
    local fetched = Components.DB:FindOne('vehicles', { VIN = vin })
    if fetched.success and #fetched.docs == 1 then 
        return fetched.docs[1]
    end
    return false
end


function IsOwnerIdentifierAvailable(id)
    local fetch = Components.DB:FindOne('vehicles', { ['Owner.Id'] = id })
    if fetch.success and #fetch.docs <= 0 then 
        return true
    end
    return false
end

--[[

? Owner Types
1 = Personal Vehicle
2 = Business/Goverment Vehicle

? Storage Types
1 = Public Garage/Normal Garage
2 = Private Garage/Property Garage

? Impound Types
false = not impounded you stupid fuckface
true = casual impound by mechanic, pd, etc. pay fee to get it out
"string" = full impound, by pd for a certain amount of time - the number is the start time of impound eg. "starting-os-time/length-hours"

{
    VIN = 'ASDASDASSD0980123',
    Owner = {
        Type = 1,
        Id = '1234',
    },
    Vehicle = 'vehiclemodel',
    Stored = { -- * or the LAST place it was stored
        Type = 1,
        Id = '1234'
    },
    Impounded = false, -- * false or type
    Fuel = 100,
    PlateRegistered = 'ABCD1234',
    PlateFake = false or table with name, plate and plate type,
    AppearanceMods = {

        -- * local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
        --* local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
        
        livery = ,
        dirt = 0-15, NO THIS IS STORED AS DAMAGE -- (it easier)
        color1 = ,
        color2 = ,
        pearlescent = ,-- * GetVehicleExtraColours

        wheelsType = -1, -- * GetVehicleWheelType
        wheelsColor = -1, -- * GetVehicleExtraColours
        frontWheels = -1, -- * GetVehicleMod(vehicle, 23),
        backWheels = -1, -- * GetVehicleMod(vehicle, 24),
        tyreSmoke = false, -- * IsToggleModOn(vehicle, 20),
        tyreSmokeColor = {
            r = 1,
            g = 1,
            b = 1,
        },

        horns = -1, -- * GetVehicleMod(vehicle, 14)

        tints = 0-6, --* GetVehicleWindowTint

        xenons = false, -- * IsToggleModOn(vehicle, 22),
        xenonsColor = -1 0-12, -- * GetVehicleXenonLightsColour

        neonsColor = ,
        neons = [ --* IsVehicleNeonLightEnabled
            0,
            1,
            2,
            3
        ],

        extras = {
            1 = boolean,
            2 = boolean,
            3 = boolean,
            4 = boolean,
            5 = boolean,
            6 = boolean,
            7 = boolean,
            8 = boolean,
            9 = boolean,
            10 = boolean,
            11 = boolean,
            12 = boolean,
            13 = boolean,
            14 = boolean
        },

        spoilers = -1, -- * GetVehicleMod(vehicle, 0),
        frontBumper = -1, -- * GetVehicleMod(vehicle, 1),
        rearBumper = -1, -- * GetVehicleMod(vehicle, 2),
        sideSkirt = -1, -- * GetVehicleMod(vehicle, 3),
        exhaust = -1, -- * GetVehicleMod(vehicle, 4),
        frame = -1, -- * GetVehicleMod(vehicle, 5),
        grille = -1, -- * GetVehicleMod(vehicle, 6),
        hood = -1, -- * GetVehicleMod(vehicle, 7),
        fender = -1, -- * GetVehicleMod(vehicle, 8),
        rightFender = -1, -- * GetVehicleMod(vehicle, 9),
        roof = -1, -- * GetVehicleMod(vehicle, 10),

        plateHolder = -1, -- * GetVehicleMod(vehicle, 25),
        vanityPlate = -1, -- * GetVehicleMod(vehicle, 26),
        trimA = -1, -- * GetVehicleMod(vehicle, 27),
        trimB = -1, -- * GetVehicleMod(vehicle, 44),
        ornaments = -1, -- * GetVehicleMod(vehicle, 28),
        dashboard = -1, -- * GetVehicleMod(vehicle, 29),
        dial = -1, -- * GetVehicleMod(vehicle, 30),
        doorSpeaker = -1, -- * GetVehicleMod(vehicle, 31),
        seats = -1, -- * GetVehicleMod(vehicle, 32),
        steeringWheel = -1, -- * GetVehicleMod(vehicle, 33),
        shifterLeavers = -1, -- * GetVehicleMod(vehicle, 34),
        aPlate = -1, -- * GetVehicleMod(vehicle, 35),
        speakers = -1, -- * GetVehicleMod(vehicle, 36),
        trunk = -1, -- * GetVehicleMod(vehicle, 37),
        hydrolic = -1, -- * GetVehicleMod(vehicle, 38),
        engineBlock = -1, -- * GetVehicleMod(vehicle, 39),
        airFilter = -1, -- * GetVehicleMod(vehicle, 40),
        struts = -1, -- * GetVehicleMod(vehicle, 41),
        archCover = -1, -- * GetVehicleMod(vehicle, 42),
        aerials = -1, -- * GetVehicleMod(vehicle, 43),
        tank = -1, -- * GetVehicleMod(vehicle, 45),
        windows = -1, -- * GetVehicleMod(vehicle, 46),
    },
    PerformanceMods = {
        engine = -1, --* GetVehicleMod(vehicle, 11)
        brakes = -1, -- * GetVehicleMod(vehicle, 12)
        transmission = -1, -- *GetVehicleMod(vehicle, 13)
        suspension = -1, -- * GetVehicleMod(vehicle, 15)
        armor = -1, -- * GetVehicleMod(vehicle, 16)
        turbo = boolean,

    },
    Damage = {
        engineHealth = 1000.0,
        bodyHealth = 1000.0,
        missingDoors = [
            1,
            2
        ],
        burstTyres = [
            
        ]
    },
}
]]

AddEventHandler('ARP:Shared:Components:RegisterReady', function(resource)
    exports['arp-base']:RegisterComponent('Vehicles', VEHICLES)
end)