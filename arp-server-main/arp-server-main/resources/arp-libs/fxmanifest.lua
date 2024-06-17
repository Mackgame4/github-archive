fx_version 'cerulean'
game 'gta5'

author 'Dr Nick'
description 'AuthenticRP Utility Functions'

server_scripts {
    'server/identifiers.js'
}

shared_scripts {
    'shared.js'
}

files {-- so it is available for client scripts
    'util.lua',
    'componentLoader.lua',
    'client/util.lua',
    'client/character.lua',
}