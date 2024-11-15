fx_version 'cerulean'
game 'gta5'

shared_scripts {
	'@_core/imports.lua',
	'locales/*.lua'
}

server_scripts {
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'config.lua',
	'client/main.lua',
	'client/clotheShops.lua',
	'client/barberShops.lua',
	'client/tattooShops.lua'
}

dependencies {
	'_core'
}

files {
	'AllTattoos.json'
}