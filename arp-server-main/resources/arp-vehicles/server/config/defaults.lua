function GetInitialAppearanceData(vehicle) --! do something about custom default in here somewhere
    local _color1, _color2 = GetVehicleColours(vehicle)
    local _pearlescent, _wheelsColor = GetVehicleExtraColours(vehicle)

    local _extras = {}
    for i = 1, 14 do
        _extras[i] = false
    end

    return {
        color1 = _color1,
        color2 = _color2,
        pearlescent = _pearlescent,
        wheelsType = GetVehicleWheelType(vehicle),
        wheelsColor = _wheelsColor,
        tireSmoke = false,
        tireSmokeColor = {
            r = 255,
            g = 0,
            b = 0,
        },
        tints = 0,
        xenons = false,
        xenonsColor = -1,
        horns = -1,
        -- neons
        -- neonsColor
        extras = _extras,
    }
end

function GetInitialPerformanceData()
    return {
        engine = -1,
        brakes = -1,
        transmission = -1,
        suspension = -1,
        armor = -1,
        turbo = false,
    }
end