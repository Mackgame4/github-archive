function GetCharacterDamage()
    if CHAR_DATA and CHAR_DATA.Damage and CHAR_DATA.Damage.Limbs then 
        return CHAR_DATA.Damage.Limbs
    else
        return {}
    end
end

function GetCharacterStats()
    return {
        health = LocalPlayer.state.dead and 0 or LocalPlayer.state.health,
        armour = LocalPlayer.state.dead and 0 or LocalPlayer.state.armour,
        hunger = 100,
        thirst = 100,
        stress = 100,
        oxygen = LocalPlayer.state.dead and 0 or 100,
    }
end