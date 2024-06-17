fx_version 'cerulean'
game 'gta5'

author 'Dr Nick'
description 'The Fucking Phone'

server_scripts {
    '@arp-libs/util.lua',
    '@arp-libs/server/functions.lua',
    '@arp-libs/componentLoader.lua',
    'server/sv_startup.lua',
}

client_scripts {
    '@arp-libs/util.lua',
    '@arp-libs/client/util.lua',
    '@arp-libs/componentLoader.lua',
    '@arp-libs/client/character.lua',
    'client/cl_startup.lua',
    'client/cl_main.lua',
    'client/cl_nui.lua',
}

files {
    'ui-dev/index.html',
}

ui_page 'ui-dev/index.html'