fx_version 'cerulean'
game 'gta5'

author 'Dr Nick'

server_scripts {
    '@arp-libs/util.lua',
    '@arp-libs/server/functions.lua',
    '@arp-libs/componentLoader.lua',
    'configs/*.lua',
    'server/*.lua',
}

client_scripts {
    '@arp-libs/util.lua',
    '@arp-libs/componentLoader.lua',
    'client/cl_main.lua'
}
