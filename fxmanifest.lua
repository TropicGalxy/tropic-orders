fx_version 'cerulean'
game 'gta5'

lua54 'yes'
author 'TropicGalxy'
description 'a very simple script to allow for restraining orders and trespassing'
version '1.0.0'


shared_script '@ox_lib/init.lua'

server_scripts {
    'server.lua',
    '@oxmysql/lib/MySQL.lua'
}

client_scripts {
    'client.lua'
}
