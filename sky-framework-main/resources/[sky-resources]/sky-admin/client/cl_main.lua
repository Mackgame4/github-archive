RegisterNetEvent('Core:Shared:PlayerLoaded', function()
    
end)

RegisterCommand('show-nui', function()
  toggleNuiFrame(true)
  debugPrint('Show NUI frame')
end)