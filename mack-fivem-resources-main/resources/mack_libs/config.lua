Config = {}

-- Functional config
Config.Debug = true -- Default: "false"
Config.DebugLevel = 3 -- Default: "1" / Options: 0 = None, 1 = Info, 2 = Warning, 3 = All
Config.StopFiveMStock = true -- Default: "true" (Stops FiveM stock resources from loading - Changing this can cause issues with other addons)
Config.DBMode = "mongodb" -- Default: "mongodb" / Options: "mysql" (https://github.com/brouznouf/fivem-mysql-async) or "mongodb" (https://github.com/Mackgame4/fivem-mongodb)
Config.Framework = "standalone" -- Default: "standalone" / Options: "esx" or "qbus" (Coming Soon)

-- Server Config
Config.WelcomeText = "Welcome to ^4%s^0, %s!" -- %s = Server Name, %s = Player Name