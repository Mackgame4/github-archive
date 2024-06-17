--[[local actionsOpen = false
local actionItems = {

        test = {
            title = 'Test',
            text = 'Test text',
            icon = 'mdi-aws'
        },

        garage = false,

}

AddEventHandler('Interaction:KeyBindings:KeyDown', function(key, modifier)
    if key == 'interactionGeneralMenu' then 
        INTERACTION:Menu({title = 'Personal Actions', icon = 'mdi-gesture-double-tap'}, actionItems, function(primary, secondary)
            print(primary, secondary)
            TriggerEvent('Interaction:ActionMenu:DoSomething', primary, secondary)
        end)
    end
end)

AddEventHandler('Interaction:ActionMenu:Add', function(id, title, text, icon, secondary)
    actionItems[id] = {
        title = title,
        text = text,
        icon = icon,
        secondary = secondary
    }
end)

AddEventHandler('Interaction:ActionMenu:Delete', function(id)
    if actionItems[id] then 
        actionItems[id] = false
    end
end)]]