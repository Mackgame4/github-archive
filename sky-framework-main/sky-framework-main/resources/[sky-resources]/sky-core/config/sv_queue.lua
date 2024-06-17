Core.Config.Queue = {
    Settings = {
        Enabled = true,
        InitialWaitTimes = {
            standard = 5,
            staff = 0.5,
            developer = 0,
            job = 2
        },
        MaxTimeBoost = 10,
        Grace = 5
    },
    Images = {
        Background = 'https://cdn.discordapp.com/attachments/915728668347756605/944912065817112596/Starter_V5.jpg',
    },
    ExcludeDrop = {
        'Exiting',
        'Disconnected',
        'cup-leopard-triple',
        'Kicked',
        'Banned'
    },
    AllowedJobQueue = {
        "ambulance", "police", "fire"
    },
    Strings = {
        Add = 'Added %s (SID: %s, Identifier: %s) To Queue %s/%s',
        Banned = 'You\'re Banned, %s\nExpires: %s\nID: %s',
        Checking = 'Checking Whitelist Status',
        DatabaseWait = 'Waiting For Server To Be Ready, Please Wait (%s - %s - %s)\n\nIf The Emotes Stop Changing, Please Reconnect',
        Disconnected = '%s (SID: %s, Identifier: %s) Disconnected, Starting Grace',
        Dropped = 'Dropped From Server.',
        Dropping = '^8Dropping Lowest Priority Player For Privileged Player %s',
        Grace = '^5Starting Grace Timer For %s - Ends At %s^7',
        Joined = '%s (SID: %s, Identifier: %s) Joined The Server',
        Joining = 'Joining Server...',
        NoAccountData = 'Unable To Get Your Account Data, Please Try Again.',
        NoLicense = 'No License Identifier, Please Relaunch FiveM. Contact FiveM Support If This Continues',
        NotWhitelisted = 'Not White listed',
        PermaBanned = 'Permanently Banned.\n\nReason: %s\nID: %s',
        PrioAdd = 'Added %s (%s) To Queue %s/%s With Priority %s',
        PrioWaiting = 'Waiting For Priority Player To Join Server',
        Queued = 'Position %s of %s - Time In Queue: %s%s',
        Retrieving = 'Retrieving Queue Information',
        Waiting = 'Waiting For Queue To Open - %s Seconds'
    },
    Emotes = { '🍕','🍔','🍟','🌭','🍿','🥓','🥚','🍳','🧇','🥞','🧈','🍞','🥐','🥨','🥯','🥖','🧀','🥗','🥙','🥪','🌮','🌮','🌯','🥫','🍖','🍗','🥩','🍠','🥟','🥠','🥡','🍱','🍘','🍙','🍚','🍛','🍜','🦪','🦪','🍣','🍤','🍥','🥮','🍢','🧆','🥘','🍲','🍝','🥣','🥧','🍦','🍧','🍨','🍩','🍪','🎂','🍰','🧁','🍫','🍬','🍭','🍡','🍮','🍯','🍼' }
}