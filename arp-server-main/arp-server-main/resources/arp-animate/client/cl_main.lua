ANIMATE = {}

function OnComponentUpdate(c)

end

AddEventHandler('ARP:Shared:Components:RegisterReady', function()
    exports['arp-base']:RegisterComponent('Animate', ANIMATE)
end)