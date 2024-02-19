local prefix = "vib_telemetry:menus"

local function e(path)
    return ("%s:%s"):format(prefix, path)
end

MENUS = {
    MAIN = e("MAIN"),
    SPEED_TESTING = {
        MAIN = e("st:MAIN"),
        GROUP_AUTOMATIC_TESTING = {
            MAIN = e("st:gat:MAIN"),
            SELECT = e("st:gat:SELECT"),
            ADD_VEHICLES = {
                MAIN = e("st:gat:av:MAIN"),
                BROWSE_CATEGORIES = e("st:gat:av:BROWSE_CATEGORIES"),
            },
            BROWSE_VEHICLES = {
                MAIN = e("st:gat:bv:MAIN"),
                ADD_TO_ANOTHER_GROUP = e("st:gat:bv:ADD_TO_ANOTHER_GROUP"),
            }
        },
        CATEGORY_AUTOMATIC_TESTING = e("st:CATEGORY_AUTOMATIC_TESTING"),
    },
    VEHICLE_PERFORMANCE = {
        MAIN = e("vp:MAIN"),
        PERFORMANCE_UPGRADES = e("vp:PERFORMANCE_UPGRADES"),
    },
    PAST_RUNS = {
        MAIN = e("pr:MAIN"),
        GROUP = {
            MAIN = e("pr:g:MAIN"),
            SPEED_TESTS = e("pr:g:SPEED_TESTS"),
            OPTIONS = e("pr:g:OPTIONS"),
        },
        CATEGORY = {
            MAIN = e("pr:c:MAIN"),
            SPEED_TESTS = e("pr:g:SPEED_TESTS"),
            OPTIONS = e("pr:c:OPTIONS"),
        },
    },

    SpeedTest = {
        Main = e("st:main"),
        Automatic = e("st:automatic"),
        Manual = e("st:manual"),
        Category = e("st:category"),
        Group = e("st:group"),
        GroupOptions = e("st:group_options"),
        GroupAddVehicle = e("st:group_add_vehicle"),
        SelectCategoryForAddToGroup = e("st:select_category_for_add_to_group"),
    },
    Upgrades = {
        Main = e("u:main"),
    },
    ExtraOptions = {
        Main = e("eo:main"),
    },
}