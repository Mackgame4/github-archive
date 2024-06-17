local shouldExecuteBind = false

Citizen.CreateThread(function()
    if not Core.Modules.Functions:IsRDR() then
        Core.Modules.Keybinds = {
            ShouldExecute = function(self, toggle)
                shouldExecuteBind = toggle
            end,
            AddBind = function(self, name, category, description, onKeyDownCommand, onKeyUpCommand, default, event, type)
                if not default then default = "" end
                if not type then type = "keyboard" end
                if not category then
                    Core.Modules.Logger:Error('Keybinds', 'No Category provided for keymap when key is event')
                    return
                end
                if not description then
                    Core.Modules.Logger:Error('Keybinds', 'No Description provided for keymap when key is event')
                    return
                end
                if not name and event then
                    Core.Modules.Logger:Error('Keybinds', 'No Name provided for keymap when key is event')
                return
                end
                local desc = "(" .. category .. ")" .. " " .. description

                local cmdStringDown = "+cmd_wrapper__" .. onKeyDownCommand
                local cmdStringUp = "-cmd_wrapper__" .. onKeyDownCommand
                
                RegisterCommand(cmdStringDown, function()
                    if not shouldExecuteBind then return end
                    if event then TriggerEvent("Sky:KeyEvent", name, false) end
                    ExecuteCommand(onKeyDownCommand)
                end, false)
                RegisterCommand(cmdStringUp, function()
                    if not shouldExecuteBind then return end
                    if event then TriggerEvent("Sky:KeyEvent", name, true) end
                    ExecuteCommand(onKeyUpCommand)
                end, false)
                RegisterKeyMapping(cmdStringDown, desc, type, default)
                TriggerEvent('chat:removeSuggestion', cmdStringDown)
                TriggerEvent('chat:removeSuggestion', cmdStringUp)
            end,
            Add = function(self, name, category, description, onDown, onUp, default, event, type)
                if not default then default = "" end
                if not type then type = "keyboard" end
                if not category then
                    Core.Modules.Logger:Error('Keybinds', 'No Category provided for keymap when key is event')
                    return
                end
                if not description then
                    Core.Modules.Logger:Error('Keybinds', 'No Description provided for keymap when key is event')
                    return
                end
                if not name and event then
                    Core.Modules.Logger:Error('Keybinds', 'No Name provided for keymap when key is event')
                    return
                end
                
                self:AddBind((name or ""), category, description, "+sky_"..name, "-sky_"..name, default, event, type)
                RegisterCommand('+sky_'..name, onDown, false)
                RegisterCommand('-sky_'..name, onUp, false)
            end
        }

        Core.Modules.Keybinds:Add('interactions-generalUse', 'Interactions', 'General Use', function() end, function() end, "E", true)

        AddEventHandler('Sky:KeyEvent', function(event, action)
            if event ~= "interactions-generalUse" then return end
            if action then
                TriggerEvent('Sky:GeneralUse')
            end
        end)
    else

    end
end)

RegisterNetEvent('Core:Shared:CharacterSpawned', function()
    shouldExecuteBind = true
end)

RegisterNetEvent('Core:Shared:CharacterLogout', function()
    shouldExecuteBind = false
end)