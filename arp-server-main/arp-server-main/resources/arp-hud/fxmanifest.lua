fx_version 'cerulean'
game 'gta5'

author 'Dr Nick'
description 'AuthenticRP HUD'

-- server_scripts {
--     '@arp-libs/util.lua',
--     '@arp-libs/server/functions.lua',
--     'server/sv_startup.lua',
-- }

client_scripts {
    '@arp-libs/util.lua',
    '@arp-libs/componentLoader.lua',
    '@arp-libs/client/util.lua',
    '@arp-libs/client/character.lua',
    'client/cl_utils.lua',
    'client/cl_settings.lua',
    'client/cl_nui.lua',
    'client/cl_binds.lua',
    'client/cl_main.lua',
    'client/cl_compass.lua',
    'client/cl_vehicle.lua',
    'client/cl_character.lua',
}

files {
    'ui/js/*.js',
    'ui/img/*.svg',
    'ui/fonts/*.ttf',
    'ui/fonts/*.woff',
    'ui/fonts/*.woff2',
    'ui/fonts/*.eot',
    'ui/css/*.css',
    'ui/index.html',
    'ui/assets/*.png',
}

ui_page 'ui/index.html'