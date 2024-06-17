RegisterNetEvent('Vehicles:Client:ApplyToVehicle')
AddEventHandler('Vehicles:Client:ApplyToVehicle', function(vehicle, appearance, performance, damage)
    vehicle = NetToVeh(vehicle)
    NetworkRequestControlOfEntity(vehicle)
    if NetworkHasControlOfEntity(vehicle) and type(appearance) == 'table' and type(performance) == 'table' then 

        --SetVehicleDoorsLocked(vehicle, 2)
        ApplyVehicleAppearance(vehicle, appearance)
        ApplyVehiclePerformance(vehicle, performance)

        if damage and type(damage) == 'table' then
            if type(damage.engineHealth) == 'number' and type(damage.bodyHealth) == 'number' then 
                if damage.engineHealth <= 100.0 then 
                    SetVehicleEngineHealth(vehicle, -400.0)
                else
                    SetVehicleEngineHealth(vehicle, damage.engineHealth + 0.0)
                end
                print('engine', damage.engineHealth)
                print('body', damage.bodyHealth)

                SetVehicleBodyHealth(vehicle, damage.bodyHealth + 0.0)

                local randomDamageMax = ARP.Round(damage.bodyHealth / 100, 0)
                if randomDamageMax < 2 then randomDamageMax = 2 end
                if randomDamageMax <= 5.0 then 
                    for window = 0, 13 do
                        if ARP.RandomNumber(1, randomDamageMax + 1) == 1 then 
                            SmashVehicleWindow(vehicle, window)
                        end
                    end

                    for tyre = 0, 8 do 
                        if ARP.RandomNumber(1, randomDamageMax + 2) == 1 then 
                            SetVehicleTyreBurst(vehicle, tyre, false, 980.0)
                        end
                    end
                end

                --[[if damage.bodyHealth <= 0.0 and damage.engineHealth >= -1000.0 then -- you done fucked up
                    NetworkExplodeVehicle(vehicle, false, false, false)
                    StopFireInRange(GetEntityCoords(vehicle), 1.5)
                end]]
            end

            if type(damage.missingDoors) == 'table' then 
                SetAllVehicleMissingDoors(vehicle, damage.missingDoors)
            end

            if type(damage.burstTyres) == 'table' then 
                SetAllVehicleBurstTyres(vehicle, damage.burstTyres)
            end

            if type(damage.dirtLevel) == 'number' and damage.dirtLevel >= 0 and damage.dirtLevel <= 15 then 
                SetVehicleDirtLevel(vehicle, damage.dirtLevel + 0.0)
            else
                SetVehicleDirtLevel(vehicle, 0)
            end
        end
    end
end)

function ApplyVehicleAppearance(vehicle, data)
    SetVehicleColours(vehicle, data.color1, data.color2)
    SetVehicleExtraColours(vehicle, data.pearlescent, data.wheelsColor)

    SetVehicleWheelType(vehicle, data.wheelsType)
    if data.frontWheels and data.frontWheels >= 0 then 
        SetVehicleMod(vehicle, 23, data.frontWheels, false)
    end
    if GetVehicleClass(vehicle) == 8 and data.backWheels and data.backWheels >= 0 then
        SetVehicleMod(vehicle, 24, data.backWheels, false)
    end

    if data.tyreSmoke and data.tyreSmokeColor and data.tyreSmokeColor.r and data.tyreSmokeColor.g and data.tyreSmokeColor.b then 
        ToggleVehicleMod(vehicle, 20, true)
        SetVehicleTyreSmokeColor(vehicle, data.tyreSmokeColor.r, data.tyreSmokeColor.g, data.tyreSmokeColor.b)
    else
        ToggleVehicleMod(vehicle, 20, false)
    end

    local function hasNeon(index)
        if data.neons and type(data.neons) == 'table' then 
            if ARP.GetPositionInOrderedTable(data.neons, index) ~= nil then 
                return true
            end
        end
        return false
    end

    for i = 0, 3 do 
        print('neon', i, hasNeon(i))
        SetVehicleNeonLightEnabled(vehicle, i, hasNeon(i))
    end

    if data.neonsColor and type(data.neonsColor) == 'table' and data.neonsColor.r and data.neonsColor.g and data.neonsColor.b then 
        SetVehicleNeonLightsColour(vehicle, data.neonsColor.r, data.neonsColor.g, data.neonsColor.b)
    end

    if data.tints and type(data.tints) == 'number' then 
        SetVehicleWindowTint(vehicle, data.tints)
    else
        SetVehicleWindowTint(vehicle, 0)
    end

    ToggleVehicleMod(vehicle, 22, data.xenons)
    SetVehicleXenonLightsColour(vehicle, -1)
    if data.xenonsColor and data.xenonsColor >= 0 and data.xenonsColor <= 12 then 
        SetVehicleXenonLightsColour(vehicle, data.xenonsColor)
    end

    local function getModValue(mod)
        if type(mod) == 'string' and data[mod] and data[mod] >= 0 then 
            return data[mod]
        end
        return -1
    end
    SetVehicleMod(vehicle, 14, getModValue('horns'))

    SetVehicleMod(vehicle, 0, getModValue('spoilers'))
    SetVehicleMod(vehicle, 1, getModValue('frontBumper'))
    SetVehicleMod(vehicle, 2, getModValue('rearBumper'))
    SetVehicleMod(vehicle, 3, getModValue('sideSkirt'))
    SetVehicleMod(vehicle, 4, getModValue('exhaust'))
    SetVehicleMod(vehicle, 5, getModValue('frame'))
    SetVehicleMod(vehicle, 6, getModValue('grille'))
    SetVehicleMod(vehicle, 7, getModValue('hood'))
    SetVehicleMod(vehicle, 8, getModValue('fender'))
    SetVehicleMod(vehicle, 9, getModValue('rightFender'))
    SetVehicleMod(vehicle, 10, getModValue('roof'))

    SetVehicleMod(vehicle, 25, getModValue('plateHolder'))
    SetVehicleMod(vehicle, 26, getModValue('vanityPlate'))
    SetVehicleMod(vehicle, 27, getModValue('trimA'))
    SetVehicleMod(vehicle, 44, getModValue('trimB'))
    SetVehicleMod(vehicle, 28, getModValue('ornaments'))
    SetVehicleMod(vehicle, 29, getModValue('dashboard'))
    SetVehicleMod(vehicle, 30, getModValue('dial'))
    SetVehicleMod(vehicle, 31, getModValue('doorSpeaker'))
    SetVehicleMod(vehicle, 32, getModValue('seats'))
    SetVehicleMod(vehicle, 33, getModValue('steeringWheel'))
    SetVehicleMod(vehicle, 34, getModValue('shifterLeavers'))
    SetVehicleMod(vehicle, 35, getModValue('aPlate'))
    SetVehicleMod(vehicle, 36, getModValue('speakers'))
    SetVehicleMod(vehicle, 37, getModValue('trunk'))
    SetVehicleMod(vehicle, 38, getModValue('hydrolic'))
    SetVehicleMod(vehicle, 39, getModValue('engineBlock'))
    SetVehicleMod(vehicle, 40, getModValue('airFilter'))
    SetVehicleMod(vehicle, 41, getModValue('struts'))
    SetVehicleMod(vehicle, 42, getModValue('archCover'))
    SetVehicleMod(vehicle, 43, getModValue('aerials'))
    SetVehicleMod(vehicle, 45, getModValue('tank'))
    SetVehicleMod(vehicle, 46, getModValue('windows'))

    if data.extras then 
        for extraId, extraState in ipairs(data.extras) do 
            SetVehicleExtra(vehicle, extraId, extraState and 0 or 1)
        end
    end

    if data.livery then 
        SetVehicleMod(vehicle, 48, data.livery, false)
        SetVehicleLivery(vehicle, data.livery)
    end

end

function ApplyVehiclePerformance(vehicle, data)
    local function getPerfValue(mod)
        if type(mod) == 'string' and data[mod] and data[mod] >= 0 then 
            return data[mod]
        end
        return -1
    end

    SetVehicleMod(vehicle, 11, getPerfValue('engine'))
    SetVehicleMod(vehicle, 12, getPerfValue('brakes'))
    SetVehicleMod(vehicle, 13, getPerfValue('transmission'))
    SetVehicleMod(vehicle, 15, getPerfValue('suspension'))
    SetVehicleMod(vehicle, 16, getPerfValue('armor'))
    ToggleVehicleMod(vehicle, 18, data.turbo)
end