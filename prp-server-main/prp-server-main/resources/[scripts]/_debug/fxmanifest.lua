fx_version 'cerulean'
game 'gta5'

shared_script '@_core/imports.lua'

--[[server_scripts {
	'server.lua',
}]]--

client_script {
	'client.lua',
}

files {
    'index.html',
	'script.js'
}

ui_page 'index.html'

dependencies {
	'_core'
}