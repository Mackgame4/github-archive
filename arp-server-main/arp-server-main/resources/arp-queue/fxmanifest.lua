fx_version 'cerulean'
game 'gta5'

name 'AuthenticRP Queue'
description 'Based on Bluesky Queue (Alzar) and Edited to Work on AuthenticRP'
author 'Dr Nick'

server_scripts {
    '@arp-libs/util.lua',
    '@arp-libs/server/functions.lua',
    '@arp-libs/componentLoader.lua',
    'config.lua',
    'server/*.lua'
}

server_only 'yes'