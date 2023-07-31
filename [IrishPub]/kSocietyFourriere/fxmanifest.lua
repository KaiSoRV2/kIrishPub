fx_version 'cerulean'

game 'gta5'

description 'KaiSoR Fourrière Société'
lua54 'yes'
version '1.0'
legacyversion '1.9.4'

shared_script {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
}

client_scripts {
    "client/cl_main.lua",
    "config.lua",

}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    "server/sv_main.lua",
}