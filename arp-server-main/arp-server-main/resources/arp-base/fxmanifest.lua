fx_version 'cerulean'
game 'gta5'

author 'Dr Nick'

server_scripts {
    '@arp-libs/util.lua',
    '@arp-libs/server/functions.lua',
    'server/sv_config.lua',
    'server/sv_init.lua',
    'shared/sh_components.lua',
    'shared/sh_logging.lua',
    'shared/sh_store.lua',
    'server/sv_database.lua',
    'server/sv_callbacks.lua',
    'server/sv_commands.lua',
    'server/sv_api.lua',
    'server/sv_execute.lua',
    'server/sv_user.lua',
}

client_scripts {
    '@arp-libs/util.lua',
    '@arp-libs/client/util.lua',
    'client/cl_init.lua',
    'shared/sh_components.lua',
    'shared/sh_logging.lua',
    'shared/sh_store.lua',
    'client/cl_callbacks.lua',
    'client/cl_execute.lua',
    'client/cl_discord.lua',
}