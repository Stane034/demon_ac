fx_version 'adamant'
game 'gta5'

client_script { 
    'client/entities.lua',
    'constconfig/cfg.lua',
    'client/cl.lua',
    'client/clsecly.lua'
}

server_script {
    '@mysql-async/lib/MySQL.lua',
    'constconfig/cfg.lua',
    'constconfig/scfg.lua',
    'server/sv.lua'
}

ui_page 'client/index.html'

files {
	'client/index.html'
}