Config = {}
Config.Locale = 'en'

Config.Verbose = true

Config.Accounts = {
    bank = _U('account_bank'),
    black_money = _U('account_black_money'),
    money = _U('account_money'),
    salary = "Salary"
}

Config.LanguageSelector = true -- Enable the language selector on first player join

Config.StartingAccountMoney = { bank = 50000, salary = 500 }
Config.DefaultCoords = { x = 402.89, y = -996.87, z = -100.0, heading = 175.0 }
--Config.DefaultCoords 			= {x = -269.4, y = -955.3, z = 31.2, heading = 205.8} --leaving these here incase its needed
Config.UpdateCoords = true -- Used to disable the Network consuming update coords

Config.EnableSocietyPayouts = false -- pay from the society account that the player is employed at? Requirement: esx_society
Config.EnableHud = false -- enable the default hud? Display current job and accounts (black, bank & cash)
Config.MaxWeight = 24   -- the max inventory weight without backpack
Config.PaycheckInterval = 1 * 60000 -- how often to recieve pay checks in milliseconds
Config.EnableDebug = true -- Use Debug options?
Config.EnableDefaultInventory = false -- Display the default Inventory ( F2 )
Config.EnableWantedLevel = false -- Use Normal GTA wanted Level?
Config.EnablePVP = true -- Allow Player to player combat

Config.Multichar = false -- Enable support for esx_multicharacter
Config.Identity = false -- Select a characters identity data before they have loaded in (this happens by default with multichar)

Config.Jobs = {
    Boss = {
        InteractConfig = {

        }
    },
    DefaultSalary = 1000
}

Config.NPCs = {
    DefaultDistance = 50,
    CheckTime = 2000
}
