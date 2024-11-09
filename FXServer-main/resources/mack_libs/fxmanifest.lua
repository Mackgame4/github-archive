fx_version 'cerulean'
game 'gta5'

files {
	'init.lua'
}

server_scripts {
	'server/main.lua',
	'server/db.lua',
	'server/functions.lua',
	'shared/functions.lua'
}

client_scripts {
	'client/main.lua',
	'client/functions.lua',
	'shared/functions.lua'
}

shared_scripts {
	'config.lua'
}

lua54 'yes'

dependencies {
	'spawnmanager',
	'sessionmanager'
}

exports {
	'getObject',
	'getCoreConfig'
}

server_exports {
	'getObject',
	'getCoreConfig'
}