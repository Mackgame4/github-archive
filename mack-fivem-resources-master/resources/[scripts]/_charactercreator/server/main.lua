-- this is not currently  being used... just making the characters invisible
 --nox is building the routing buckets
--[[local instances = {}
RegisterServerEvent("instance:set") 
AddEventHandler("instance:set", function(set)
    local src = source
    local instanceSource = 0

    if set then
        if set == 0 then
            for k,v in pairs(instances) do
                if v == src then 
                    table.remove(instances, k)
                end
            end
        end 
    else
        for k,v in pairs(instances) do
            if v == nil then 
                table.insert(instances, k, src)
                instanceSource = k
            end
        end
    end
    SetPlayerRoutingBucket(
        src, 
        instanceSource
    )
end)]]--


--[[Citizen.CreateThread(function() 
    Wait(10000)
    -- check if player connected
    --if not then 
     --[[
         for k,v in pairs(instances) do
                if v == src then 
                    table.remove(instances, k)
                end
            end
     ]]--
--end)