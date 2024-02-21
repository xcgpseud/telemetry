local _ = 0

EVENTS = SharedUtils.NameTableValues({
    CLIENT = {
        SPEED_TEST = {
            BEGIN_MANUAL = _,
            CANCEL_MANUAL = _,
            TELEPORT = _,
            BEGIN_AUTOMATIC = _,
            CATEGORY = {
                RUN_TEST = _,
                CANCEL_TEST = _,
            },
        },
        CONTEXT = {
            SPEED_TESTING = {
                MAIN = _,
                AUTOMATED_GROUP = {
                    MAIN = _,
                    CREATE_NEW = _,
                    GROUP = {
                        MAIN = _,
                        EXECUTE_AUTOMATIC_TEST = _,
                        ADD_VEHICLES = {
                            MAIN = _,
                            TYPE_NAMES = _,
                            BROWSE_CATEGORIES = {
                                MAIN = _,
                                SELECT_CATEGORY = _,
                            },
                        },
                        BROWSE_VEHICLES = _,
                        DELETE = _,
                    }
                },
                AUTOMATED_CATEGORY = {
                    MAIN = _,
                    SELECT = _,
                },
                AUTOMATED_SINGLE = _,
                MANUAL_SINGLE = _,
                CANCEL_ONGOING = _,
            },
            VEHICLE_PERFORMANCE = {
                MAIN = _,
                PERFORMANCE_UPGRADES = {
                    MAIN = _,
                    ENABLE_ALL_EXCEPT_ARMOUR = _,
                    DISABLE_ALL_EXCEPT_ARMOUR = _,
                    TOGGLE_ARMOUR = _,
                    SELECT_UPGRADES = _,
                },
                FIX_VEHICLE = _,
                TOGGLE_DRIFT_MODE = _,
            },
            PAST_RUNS = {
                MAIN = _,
                GROUP = {
                    MAIN = _,
                    SELECT_GROUP = _,
                    SELECT_TEST = {
                        MAIN = _,
                        VIEW_RESULTS = _,
                        DELETE = _,
                    },
                },
                CATEGORY = {
                    MAIN = _,
                    SELECT_CATEGORY = _,
                    SELECT_TEST = {
                        MAIN = _,
                        VIEW_RESULTS = _,
                        DELETE = _,
                    },
                },
            },
            TELEPORT_TO_TEST_LOCATION = _,
        },
        DIALOGUE = {
            GROUP = {
                CREATE = _,
                RENAME = _,
                DELETE = _,
                ADD_VEHICLES_TO_GROUP = {
                    SELECT_FROM_CATEGORY = _,
                },
                UPDATE_GROUP = _,
            },
        },
        DATABASE = {
            CREATE_TABLES = _,
        }
    },
})
EVENTS.CLIENT.CONTEXT.MAIN = "TELEMETRY:OPEN"