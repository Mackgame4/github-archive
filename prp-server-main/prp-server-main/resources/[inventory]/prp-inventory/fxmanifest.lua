fx_version 'adamant'
game 'gta5'
ui_page 'html/ui.html'

client_scripts {
    'client/main.lua',
    'config.lua',
    'client/actions.lua',
    'client/inventory.lua',
    'client/drop.lua',
    'client/glovebox.lua',
    'client/shop.lua',
    'client/weapons.lua',
    'client/search.lua',
    'client/stash.lua',
--  'client/holster.lua',
    'common/drop.lua',
    'common/weapons.lua',
    'client/crafting.lua',
    'utils.lua'
}

server_scripts {
    '@_core/imports.lua',
    'server/main.lua',
    'config.lua',
    'server/actions.lua',
    'server/inventory.lua',
    'server/player.lua',
    'server/drop.lua',
    'server/registering.lua',
    'server/shop.lua',
    'server/weapons.lua',
    'server/search.lua',
    'server/itemdata.lua',
    'common/drop.lua',
    'common/weapons.lua',
    'server/crafting.lua',
    'server/datacontrol.lua',
    'utils.lua'
}

files {
    'html/ui.html',
    'html/css/style.min.css',
    'html/js/inventory.js',
    'html/js/config.js',
    'html/css/jquery-ui.min.css',
    'html/css/bootstrap.min.css',
    'html/js/jquery.min.js',
    'html/js/jquery-ui.min.js',
    'html/js/bootstrap.min.js',
    'html/js/popper.min.js',

    -- JS langs
    'html/locales/en.js',
    -- IMAGES
    --'html/img/*.png',
    'html/success.wav',
    'html/fail.wav',
    'html/fail2.wav',
    -- ICONS

    'html/img/items/*.png',
}