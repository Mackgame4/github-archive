Config = {}

Config.Consumables = {
    { name = "bread", label = "Bread", weight = 1, rare = 0, can_remove = 1, hunger = 3, thirst = 0 },
    { name = "water", label = "Water", weight = 1, rare = 0, can_remove = 1, hunger = 0, thirst = 3 },
}

Config.Debug = false
Config.UpdateHUD = true -- Boolean to update status on hud
Config.StatusTimer = 7100 -- Value in ms. to update status
Config.AutoSaveStatusTimer = 138000 -- Value in ms. Currently set to 2min30
Config.factorhunger = (1000 * 100) / 2400000 -- Ratio to consume hunger's bar
Config.factorthirst = (1000 * 100) / 1800000 -- Ratio to consume thirst's bar