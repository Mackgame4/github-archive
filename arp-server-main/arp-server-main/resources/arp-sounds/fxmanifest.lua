fx_version 'cerulean'
games { 'gta5' }

client_scripts {
	'@arp-libs/util.lua',
	'@arp-libs/client/util.lua',
	"client/cl_main.lua",
}

server_scripts {
	"server/sv_main.lua",
}

ui_page "html/index.html"

files {
	"html/index.html",
	"html/sounds/*.ogg",
}