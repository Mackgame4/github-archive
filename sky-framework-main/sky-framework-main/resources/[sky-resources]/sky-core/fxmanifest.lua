fx_version "adamant"
games {"rdr3", "gta5"}
version '1.0.0'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

shared_scripts {
    'init.lua',
    'config/sh_*.lua',
    'shared/sh_*.lua',
}

client_scripts {
    'ipl/lib/common.lua',
    'ipl/lib/observers/*.lua',
    'ipl/client.lua',
    'ipl/**/*.lua',
	'config/cl_*.lua',
    'client/cl_*.lua'
}

server_scripts {
	'config/sv_*.lua',
    'server/sv_*.js',
    'server/sv_*.lua'
}

escrow_ignore {
    'config/*.lua'
}

dependencies {
    'yarn'
}

lua54 'yes'