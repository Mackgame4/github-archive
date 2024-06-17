fx_version 'cerulean'
game 'gta5'
author 'Dr Nick'

server_scripts {
    '@arp-libs/util.lua',
    '@arp-libs/server/functions.lua',
    '@arp-libs/componentLoader.lua',
    'server/sv_*.lua'
}

client_scripts {
    '@arp-libs/util.lua',
    '@arp-libs/client/util.lua',
    '@arp-libs/componentLoader.lua',
    'client/cl_main.lua',
    'client/cl_noclip.lua',
    'client/cl_dev.lua',
    'client/cl_targeting.lua'
}