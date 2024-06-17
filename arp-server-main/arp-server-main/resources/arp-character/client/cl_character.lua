local currentCharacter = false

CHARACTERS = {
    Current = function(self)
        if currentCharacter then 
            return currentCharacter
        end
        return false
    end
}

RegisterNetEvent('Characters:Client:Login')
AddEventHandler('Characters:Client:Login', function(Character)
    currentCharacter = Components.Store:Create(1, 'Character', Character)
    Components.Discord:SetText('Playing as: '.. Character._FullName)
end)

RegisterNetEvent('Characters:Client:Update')
AddEventHandler('Characters:Client:Update', function(k, v)
    if currentCharacter then 
        currentCharacter:SetData(k, v)
    end
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    currentCharacter = false
    Components.Discord:SetText('Character Selection')
end)