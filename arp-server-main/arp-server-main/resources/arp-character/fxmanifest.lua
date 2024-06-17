fx_version 'cerulean'
game 'gta5'
author 'Dr Nick'

server_scripts {
    '@arp-libs/util.lua',
    '@arp-libs/server/functions.lua',
    '@arp-libs/componentLoader.lua',
    'server/sv_config.lua',
    'server/sv_startup.lua',
    'server/sv_character.lua',
    'server/sv_outfits.lua',
    'server/sv_saving.lua'
}

client_scripts {
    '@arp-libs/util.lua',
    '@arp-libs/client/util.lua',
    '@arp-libs/componentLoader.lua',
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',

    'client/configs/*.lua',
    'client/cl_main.lua',
    'client/cl_character.lua',
    'client/cl_selection.lua',
    'client/cl_ped.lua',
    'client/cl_creator.lua',
    'client/modules/*.lua',
    'client/cl_stores.lua',
}