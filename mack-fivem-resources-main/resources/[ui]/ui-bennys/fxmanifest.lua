fx_version 'cerulean'

game 'gta5'

description 'UI Bennys'

shared_scripts {
	'@_core/imports.lua',
	'locales/*.lua'
}

files {
	'html/js/*.js',
    'html/fonts/*.ttf',
    'html/fonts/*.woff',
    'html/fonts/*.woff2',
    'html/fonts/*.eot',
    'html/css/*.css',
	'html/css/*.sass',
	'html/css/*.less',
	'html/assets/*.png',
	'html/assets/*.svg',
	'html/assets/*.gif',
	'html/img/*.png',
	'html/img/*.svg',
	'html/img/*.gif',
	'html/favicon.ico',
    'html/index.html'
}

server_scripts {
	'config.lua',
	'functions.lua',
	'server/main.lua'
}

client_scripts {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'config.lua',
	'functions.lua',
	'client/main.lua'
}

ui_page 'html/index.html'

dependencies {
	'_core'
}