fx_version 'cerulean'
game 'gta5'

author 'Dr Nick and Dr Nick Only'
description 'AuthenticRP Financial Everything'

server_scripts {
    '@arp-libs/util.lua',
    '@arp-libs/server/functions.lua',
    '@arp-libs/componentLoader.lua',
    'server/sv_config.lua',
    'server/sv_util.lua',
    'server/sv_main.lua',
    'server/sv_cash.lua',
    'server/sv_account.lua',
    'server/sv_account_*.lua',
    'server/sv_transactions.lua',
}

client_scripts {
    '@arp-libs/util.lua',
    '@arp-libs/componentLoader.lua',
    '@arp-libs/client/util.lua',
    '@arp-libs/client/character.lua',

    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    
    'client/cl_*.lua',
}