function RegisterCommands()
    Commands = exports['arp-base']:Component('Commands')
    Commands:AddDeveloper('getItem', function(User, args)
        local Character = User:GetCharacter()
        if not Character then return end
        local item = DoesItemExist(args[1])
        local amount = tonumber(args[2])
        if not item or type(amount) ~= 'number' then return end
        local characterInventory = LoadInventory('character', tostring(Character.CID))
        if not characterInventory then return end
        local succeeded = characterInventory:AddItems(item, amount, {})
    end, 'Add an Item to Your Inventory', {
        { name = 'Item', help = 'Id of the item' },
        { name = 'Amount', help = 'The amount of the item to add' }
    }, false)

    Commands:AddDeveloper('storage', function(User, args)
        OpenRemoteInventory(User.Source, 'storage', 'dev')
    end, 'Open Developer Storage', {}, false)
end