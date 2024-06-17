fx_version 'cerulean'
game 'gta5'

name 'AuthenticRP Vehicles'
author 'Dr Nick'

client_scripts {
    '@arp-libs/util.lua',
    '@arp-libs/client/util.lua',
    '@arp-libs/componentLoader.lua',
    '@arp-libs/client/character.lua',
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'config/*.lua',
    'client/cl_*.lua',
}

server_scripts {
    '@arp-libs/util.lua',
    '@arp-libs/server/functions.lua',
    '@arp-libs/componentLoader.lua',
    'server/config/*.lua',
    'config/*.lua',
    'server/sv_startup.lua',
    'server/sv_commands.lua',
    'server/sv_vehicles.lua',
    'server/sv_nitro.lua',
    'server/sv_saving.lua',
    'server/sv_identifiers.lua',
    'server/sv_keys.lua'
}