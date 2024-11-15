fx_version 'cerulean'

game 'gta5'

description 'Custom FiveM Core'

version '1.0.0'

lua54 'yes'

shared_scripts {
	'locale.lua',
	'locales/br.lua',
	'locales/en.lua',
	'config.lua',
	'config.weapons.lua',
	'common/logger.lua'
}

server_scripts {
	'@_coreExternal/async.lua',
	'server/common.lua',
	'server/classes/player.lua',
	'server/functions.lua',
	'server/paycheck.lua',
	'server/main.lua',
	'server/commands.lua',
	'server/jobs.lua',
	'server/npc.lua',
	'server/fleet.lua',
	'common/modules/math.lua',
	'common/modules/table.lua',
	'common/functions.lua'
}

client_scripts {
	'client/classes/*.lua',
	'client/common.lua',
	'client/entityiter.lua',
	'client/functions.lua',
	'client/wrapper.lua',
	'client/main.lua',
	'client/npc.lua',
	'client/fleet.lua',
	'client/modules/death.lua',
	'client/modules/scaleform.lua',
	'client/modules/streaming.lua',
	'common/modules/math.lua',
	'common/modules/table.lua',
	'common/functions.lua'
}

files {
	'imports.lua',
	'locale.js',
	'html/ui.html',
	'html/css/app.css',
	'html/js/mustache.min.js',
	'html/js/wrapper.js',
	'html/js/app.js',
	'html/fonts/pdown.ttf',
	'html/fonts/bankgothic.ttf',
	'html/img/accounts/bank.png',
	'html/img/accounts/black_money.png',
	'html/img/accounts/money.png'
}

ui_page {
	'html/ui.html'
}

exports {
	'getSharedObject',
	'ServerFirstStart',
	'getDebug'
}

server_exports {
	'getSharedObject',
	'ServerFirstStart',
	'getDebug'
}

dependencies {
	'_coreExternal',
	'spawnmanager'
}