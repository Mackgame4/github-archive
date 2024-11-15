-- Code Example --
-- Registers an item usage
AddEventHandler('ui-inventory:onItemUsage', function(item)
	print('[ui-inventory] Item usage: '..item)
    if item == 'bread' then
        print('[ui-inventory] Using bread') -- Replace by the action you want
    end
end)