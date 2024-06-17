Core = {}
Core.Modules = {}
Core.Functions = {}
Core.Config = {}


Citizen.CreateThread(function()
    Core.Internal:Init()
end)