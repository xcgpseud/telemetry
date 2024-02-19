UI.ContextMenuOptions.Main = {}

local function _doTablesExist(tables)
    return SharedUtils.Table.All(tables, function(tbl)
        return lib.callback.await(
            CALLBACKS.SERVER.DOES_TABLE_EXIST,
            false,
            tbl
        )
    end)
end

function UI.ContextMenuOptions.Main.GetMainContextMenuOptions()
    local doTablesExist = _doTablesExist({
        "telemetry_groups",
        "telemetry_speed_tests"
    })

    local output = {
        {
            title = "Speed Testing",
            description = "Run straight line speed tests on vehicles to balance vehicle handling.",
            icon = "gauge-high",
            event = EVENTS.CLIENT.CONTEXT.SPEED_TESTING.MAIN,
        },
        {
            title = "Vehicle Performance",
            description = "A series of basic upgrade/downgrade options",
            icon = "gear",
            event = EVENTS.CLIENT.CONTEXT.VEHICLE_PERFORMANCE.MAIN,
        },
        {
            title = "Past Runs",
            description = "View all past speed test runs",
            icon = "clock-rotate-left",
            event = EVENTS.CLIENT.CONTEXT.PAST_RUNS.MAIN,
        },
        {
            title = "Teleport to test location",
            description = "Teleport to the pre-configured coordinates of the test start location",
            icon = "wand-magic-sparkles",
            event = EVENTS.CLIENT.CONTEXT.TELEPORT_TO_TEST_LOCATION,
        },
    }

    if not doTablesExist then
        table.insert(output, {
            title = "Create Database Tables",
            description = "Use OxMYSQL to create the database tables required for saving groups/runs",
            icon = "database",
            event = EVENTS.CLIENT.DATABASE.CREATE_TABLES,
        })
    end

    return output
end
