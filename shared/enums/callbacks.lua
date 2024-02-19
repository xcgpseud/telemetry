local _ = 0

CALLBACKS = SharedUtils.NameTableValues({
    SERVER = {
        SPEED_TEST = {
            GROUP = {
                CREATE_GROUP = _,
                ADD_VEHICLES_TO_GROUP = _,
                GET_ALL_GROUPS = _,
                GET_GROUP_BY_ID = _,
                UPDATE_GROUP = _,
                RENAME_GROUP = _,
                DELETE_GROUP = _,
            },
            SAVE_RUN = _,
            GET_CATEGORIES_WITH_RUNS = _,
            GET_GROUPS_WITH_RUNS = _,
            GET_RUNS_FOR_CATEGORY_NAME = _,
            GET_RUNS_FOR_GROUP_ID = _,
            DELETE_TEST = _,
        },
        DOES_TABLE_EXIST = _,
        CREATE_TABLES = _,
    },
})