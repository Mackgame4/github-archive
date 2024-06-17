fx_version 'cerulean'
game 'gta5'

author 'Dr Nick'
description 'Job System'

server_scripts {
    '@arp-libs/util.lua',
    '@arp-libs/server/functions.lua',
    '@arp-libs/componentLoader.lua',
    'server/config.lua',
    'server/sv_utils.lua',
    'server/sv_startup.lua',
    'server/sv_main.lua',
}

client_scripts {
    '@arp-libs/util.lua',
    '@arp-libs/client/util.lua',
    '@arp-libs/componentLoader.lua',
    '@arp-libs/client/character.lua',
    'client/cl_startup.lua',
    'client/cl_main.lua',
    'client/cl_duty.lua',
}