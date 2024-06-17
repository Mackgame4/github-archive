Core.Config.JobConfig = {
    SharedJobs = { "police", "ambulance", "fire", "judge" }
}

Core.Config.Jobs = {
    ["police"] = {
        Workplaces = {
            ["lspd"] = {
                Name = "Los Santos Police Department",
                Grades = {
                    chief       = { Name = "Chief of Police",       isBoss = true,  doorLevel = 5, eyeLevel = 5 },
                    achief      = { Name = "Asst. Chief of Police", isBoss = true,  doorLevel = 5, eyeLevel = 5 },
                    captain     = { Name = "Captain",               isBoss = false, doorLevel = 4, eyeLevel = 4 },
                    lieutenant  = { Name = "Lieutenant",            isBoss = false, doorLevel = 3, eyeLevel = 3 },
                    sergeant    = { Name = "Sergeant",              isBoss = false, doorLevel = 2, eyeLevel = 2 },
                    officer     = { Name = "Officer",               isBoss = false, doorLevel = 1, eyeLevel = 1 },
                    cadet       = { Name = "Cadet",                 isBoss = false, doorLevel = 0, eyeLevel = 0 },
                },
            },
            ["bcso"] = {
                Name = "Blaine County Sherrifs Office",
                Grades = {
                    chief       = { Name = "Chief of Police",       isBoss = true,  doorLevel = 5, eyeLevel = 5 },
                    achief      = { Name = "Asst. Chief of Police", isBoss = true,  doorLevel = 5, eyeLevel = 5 },
                    captain     = { Name = "Captain",               isBoss = false, doorLevel = 4, eyeLevel = 4 },
                    lieutenant  = { Name = "Lieutenant",            isBoss = false, doorLevel = 3, eyeLevel = 3 },
                    sergeant    = { Name = "Sergeant",              isBoss = false, doorLevel = 2, eyeLevel = 2 },
                    officer     = { Name = "Officer",               isBoss = false, doorLevel = 1, eyeLevel = 1 },
                    cadet       = { Name = "Cadet",                 isBoss = false, doorLevel = 0, eyeLevel = 0 },
                },
            }
        },
        Departments = {
            cid = { Name = "Undercover Task Force"},
            swat = { Name = "Special Weapons and Tactics Taskforce"},
        }
    }
}