Config = {}

Config.Groups = {
    admin = 'Admin',
    developer = 'Developer',
    seniorstaff = 'Senior Staff',
    staff = 'Staff',
    whitelisted = 'Whitelisted' 
}

Config.Queue = {
    ExcludeDrop = {
        'Exiting',
        'Disconnected',
        'cup-leopard-triple',
        'Kicked',
        'Banned'
    },
    Settings = {
        QueueDelay = 1,
        MaxTimeBoost = 10,
        Grace = 5 -- Minutes
    },
    StaffPrio = {
        admin = {
            priority = 100, message = 'Admin Priority (100)'
        },
        developer = {
            priority = 99, message = 'Developer Priority (95)'
        },
        seniorstaff = {
            priority = 95, message = 'Senior Staff Priority (90)'
        },
        staff = {
            priority = 90, message = 'Staff Priority (80)'
        },
        --whitelisted = {
        --    priority = 1, message = 'Regular Priority'
        --}
    },
    Strings = {
        Add = 'Added %s (SID: %s, Steam: %s) To Queue %s/%s',
        Banned = 'You\'re Banned, Appeal At https://authenticrp.com\n\nReason: %s\nExpires: %s\nID: %s',
        Checking = 'Checking Whitelist Status',
        Disconnected = '%s (SID: %s, Steam: %s) Disconnected, Starting Grace',
        Grace = '^5Starting Grace Timer For %s - Ends At %s^7',
        Joined = '%s (SID: %s, Steam: %s) Completed the Queue',
        Joining = 'Joining Server...',
        NoAccountData = 'Not Whitelisted - Apply Today At https://authenticrp.com\n\nContact Support If You Are Whitelisted and See This.',
        NoSteam = 'No Steam Identifier, Please Relaunch FiveM.',
        Error = 'Error Joining Server, Please Try Again Later',
        PermaBanned = 'Permanently Banned\n\nReason: %s\nID: %s',
        PrioAdd = 'Added %s (%s) To Queue %s/%s With Priority %s',
        Queued = '%s Queue Position %s of %s\n\n%s',
        QueuedTime = '\nYou have been in queue for %s.\n',
        Waiting = 'Waiting For Queue To Open - %s Seconds'
    },
    Emojis = {
        '🎂',
        '🐧',
        '🐼',
        '🍄',
        '🦞',
        '🍉',
        '👻',
        '🐬',
        '🧁',
        '🍔',
        '🍕',
        '👾',
        '🍗',
        '🥝',
        '🤡',
        '🍌',
        '🦓',
        '⛄',
        '🎉',
        '🎱',
        '🐱‍',
        '🧊',
        '🍒',
        '🍩',
        '🥓',
        '🥞',
        '🥚',
        '🍰',
        '🦝',
        '🐠',
        '👽',
        '🦜',
        '🐒',
        '🐸',
    },
    PepeLaugh = {
        ['Dr Nick'] = ' 🩺',
        ['Panda_builds'] = ' 🐼',
    }
}