fx_version 'cerulean'

game 'gta5'

description 'UI Vehicleshop'

shared_script '@_core/imports.lua'

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
	'server/main.lua'
}

client_scripts {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'config.lua',
	'client/main.lua'
}

ui_page 'html/index.html'

dependencies {
	'_core'
}

exports {
	'getServerVehicles'
}