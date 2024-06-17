
-- RegisterCommand('extraon', function(src, args)
--     local extraId = tonumber(args[1])
--     if extraId then 
--         local veh = GetVehiclePedIsIn(ARP.GblPed, false)
--         SetVehicleExtra(veh, extraId, false)
--     end
-- end)

-- RegisterCommand('extraoff', function(src, args)
--     local extraId = tonumber(args[1])
--     if extraId then 
--         local veh = GetVehiclePedIsIn(ARP.GblPed, false)
--         SetVehicleExtra(veh, extraId, true)
--     end
-- end)

-- RegisterCommand('extrasoff', function(src, args)
--     local veh = GetVehiclePedIsIn(ARP.GblPed, false)
--     for i = 1, 15 do 
--         SetVehicleExtra(veh, i, true)
--     end
-- end)

-- RegisterCommand('extrason', function(src, args)
--     local veh = GetVehiclePedIsIn(ARP.GblPed, false)
--     for i = 1, 15 do 
--         SetVehicleExtra(veh, i, false)
--     end
-- end)