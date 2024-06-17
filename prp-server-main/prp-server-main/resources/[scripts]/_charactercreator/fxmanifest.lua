fx_version 'cerulean'
game 'gta5'

shared_scripts {
	'@_core/imports.lua',
	'locales/*.lua'
}

server_scripts {
	'server/main.lua'
}

client_scripts {
	'client/charactercreator.lua',
	'client/charcreatorevents.lua'
}

dependencies {
	'_core'
}