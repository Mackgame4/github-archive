
MEDICAL = {
    Kill = function(self, src)
        local Character = Components.Characters:Source(src)
        if Character then 
            Character:SetData('Dead', true)
        end

        TriggerClientEvent('Medical:Client:ForceDeath', src)
    end,
    Heal = function(self, src)
        local Character = Components.Characters:Source(src)
        if Character then 
            print('hello')
            Character:SetData('Dead', false)
        end

        TriggerClientEvent('Medical:Client:Revive', src)
    end,
}

AddEventHandler('ARP:Shared:Components:RegisterReady', function(resource)
    exports['arp-base']:RegisterComponent('Medical', MEDICAL)
end)