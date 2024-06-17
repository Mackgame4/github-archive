local alwaysDisabledKeys = {
    261,
    262,
    53,
    37,
    12,
    13,
    14,
    15,
    16,
    17,
    157,
    158,
    159,
    160,
    161,
    162,
    163,
    164,
    165,
    81,
    82,
    83,
    84,
    85,
    332,
    333,
}

Citizen.CreateThread(function()
    while true do 
        DontTiltMinimapThisFrame()
        HideHudComponentThisFrame(6)
        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(9)
        HideHudComponentThisFrame(6)
        HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(19)
        HideHudComponentThisFrame(20)
    
        for _, key in ipairs(alwaysDisabledKeys) do
            DisableControlAction(1, key, true)
        end
        Citizen.Wait(0)
    end
end)