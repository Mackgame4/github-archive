fx_version 'cerulean'
game 'gta5'

shared_script '@_core/imports.lua'

client_scripts {
	'cl_config.lua',
	'cl_debugger.lua',
}

files {
	'html/index.css',
	'html/index.html',
	'html/index.js',
}

ui_page 'html/index.html'

dependencies {
	'_core'
}