fx_version 'cerulean'
game 'gta5'

shared_script '@_core/imports.lua'

server_scripts {
	'config.lua',
	'server.lua'
}

client_scripts {
	'config.lua',
	'client.lua'
}

dependencies {
	'_core'
}