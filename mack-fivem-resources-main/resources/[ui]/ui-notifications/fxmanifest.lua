fx_version 'cerulean'

game 'common'

description 'UI Notifications'

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
	'server/main.lua'
}

client_scripts {
	'client/main.lua'
}

ui_page 'html/index.html'