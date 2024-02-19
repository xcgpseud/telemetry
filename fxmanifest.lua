fx_version "cerulean"
game "gta5"
lua54 "yes"

author "pseud"
description ""

version "0.0.1"

shared_scripts {
    "@ox_lib/init.lua",
    "shared/utils/**.lua",
    "shared/enums/**.lua",
    "shared/config/**.lua",
    "shared/entities/**.lua",
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',

    -- Static
    "server/config/**.lua",
    "server/database/queries/**.lua",
    "server/utils/**.lua",

    -- In order of use (reverse repository)
    "server/database/repositories/**.lua",
    "server/services/**.lua",
    "server/callbacks/**.lua",

    -- State
    "server/context.lua",
}

client_scripts {
    -- Static
    "client/config/**.lua",
    "client/utils/**.lua",

    -- State
    "client/context.lua",

    -- In order of use
    "client/services/**.lua",
    "client/events/**.lua",

    -- UI
    "client/ui/bootstrap.lua",
    "client/ui/context_menus/**.lua",
    "client/ui/context_menu_options/**.lua",
    "client/ui/dialogues/**.lua",
}

escrow_ignore {
    "client/config/config.lua",
    "shared/config/config.lua",
    "server/config/main_commands.lua",
}