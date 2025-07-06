fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'GoodNetwork'
description 'The best FiveM hud'
version '2.0.1'

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua'
}
client_scripts {
    'client/*.lua'
}

files {
    'html/index.html',
    'html/assets/js/**',
    'html/assets/css/**',
    'html/assets/img/**',
    'stream/hud_reticle.gfx',
    'stream/minimap.gfx'
}

ui_page 'html/index.html'

data_file 'DLC_ITYP_REQUEST' 'stream/minimap.gfx'

/* -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Thank you for using our scripts, all comments are welcome and help us be better.
-- This and most of our scripts are FREE, but to continue creating them I would like you to support me with a donation via PayPal: https://paypal.me/DARK4K?country.x=MX&locale.x=es_XC
-- Join our discord for more free scripts: https://discord.gg/4PgngbsR5T

-- [ES]
-- Gracias por utilizar nuestros scripts, todos los comentarios son bienvenidos y nos ayudan a ser mejores.
-- Este y la mayoría de nuestros scripts son GRATIS, pero para seguir creándolos me gustaría que me apoyaras con una donación vía PayPal: https://paypal.me/DARK4K?country.x=MX&locale.x=es_XC
-- Únase a nuestro discord para obtener más scripts gratuitos: https://discord.gg/4PgngbsR5T

-- GoodNetwork by @Darkmxg, Thanks */