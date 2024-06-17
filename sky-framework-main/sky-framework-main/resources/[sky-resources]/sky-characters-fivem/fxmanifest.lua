fx_version "cerulean"

description "Basic React (TypeScript) & Lua Game Scripts Boilerplate"
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
author "RoswellUK | Original Credit: Project Error"
version '1.0.0'
repository 'https://git.skyframework.net/SkyFramework/Sky-Boilerplate-RJS'

lua54 'yes'

games {
  "gta5",
  "rdr3"
}

shared_scripts {
  'init.lua',
  'config/sh_*.lua',
  'shared/sh_*.lua',
}

client_scripts {
  'config/cl_*.lua',
  'client/cl_*.lua',
  'register.lua',
}

server_scripts {
  'config/sv_*.lua',
  'server/sv_*.lua',
  'register.lua',
}

ui_page 'web/build/index.html'

files {
  'web/build/index.html',
  'web/build/**/*'
}