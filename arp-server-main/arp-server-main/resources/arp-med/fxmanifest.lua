fx_version 'cerulean'
game 'gta5'

author 'Dr Nick'
description 'ARP Medical'

server_scripts {
    '@arp-libs/util.lua',
    '@arp-libs/server/functions.lua',
    '@arp-libs/componentLoader.lua',
    'config.lua',
    'server/sv_main.lua',
    'server/sv_component.lua',
    'server/sv_commands.lua',
    'server/sv_callbacks.lua',
}

client_scripts {
    '@arp-libs/util.lua',
    '@arp-libs/client/util.lua',
    '@arp-libs/componentLoader.lua',
    '@arp-libs/client/character.lua',
    'config.lua',
    'client/cl_startup.lua',
    'client/cl_main.lua',
    'client/cl_component.lua',
    'client/cl_wounds.lua',
}