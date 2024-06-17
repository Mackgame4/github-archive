fx_version 'cerulean'
game 'gta5'
author 'Dr Nick' -- Copied directly from bluesky because I was the original author

server_scripts {
    '@arp-libs/util.lua',
    '@arp-libs/server/functions.lua',
    '@arp-libs/componentLoader.lua',
    'config/config.lua',
    'server/sv_main.lua'
}

client_scripts {
    '@arp-libs/util.lua',
    '@arp-libs/client/util.lua',
    '@arp-libs/componentLoader.lua',
    '@arp-libs/client/character.lua',
    'config/*.lua',
    'client/cl_utils.lua',
    'client/cl_main.lua',
    'client/cl_emotes.lua',
    'client/cl_features.lua',
    'client/cl_bindings.lua',
}