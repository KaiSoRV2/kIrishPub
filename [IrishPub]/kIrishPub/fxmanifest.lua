fx_version 'cerulean'

game 'gta5'

description 'KaiSoR IrishPub'
lua54 'yes'
version '2.0'
legacyversion '1.9.4'

shared_script {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
}

client_scripts {
    
    "client/cl_boss.lua",
    "client/cl_garage.lua",
    "client/cl_retour_garage.lua",
    "client/cl_function.lua",
    "client/cl_vestiaire.lua",
    "client/cl_menuF6.lua",
    "client/cl_livraison.lua",
    "client/cl_farm.lua",
    "client/cl_comptoir.lua",
    "config.lua",

}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    "server/sv_menuF6.lua",
    "server/sv_main.lua",
    "server/sv_garage.lua",
    "server/sv_livraison.lua",
    "server/sv_retour_garage.lua",
    "server/sv_farm.lua",
    "server/sv_boss.lua"
}