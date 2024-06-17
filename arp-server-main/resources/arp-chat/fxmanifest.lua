fx_version 'cerulean'
game 'gta5'

client_scripts {
    '@arp-libs/util.lua',
    '@arp-libs/componentLoader.lua',
    '@arp-libs/client/util.lua',
    '@arp-libs/client/character.lua',
    'client/cl_main.lua',
}

server_scripts {
    '@arp-libs/util.lua',
    '@arp-libs/server/functions.lua',
    '@arp-libs/componentLoader.lua',
    'server/sv_main.lua',
}

file 'chat.css'

chat_theme 'gtao' {
    styleSheet = 'chat.css',
    msgTemplates = {
        default = '<div class="arp-message">{0} - {1}</div>'
    }
}