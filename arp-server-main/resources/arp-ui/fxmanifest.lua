fx_version 'cerulean'
game 'gta5'

name 'AuthenticRP UI'
author 'Dr Nick'

client_scripts {
    '@arp-libs/componentLoader.lua',
    'client/cl_ui.lua',
    'client/cl_notify.lua'
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
    'ui/assets/inventory/items/*.png'
}

ui_page 'ui/index.html'
