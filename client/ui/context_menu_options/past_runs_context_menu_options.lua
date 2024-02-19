UI.ContextMenuOptions.PastRuns = {
    Group = {},
    Category = {},
}

function UI.ContextMenuOptions.PastRuns.GetMainContextMenuOptions()
    local events = EVENTS.CLIENT.CONTEXT.PAST_RUNS

    local out = {
        {
            title = "Past [Group] Runs",
            description = "Browse groups which have past runs associated with them",
            icon = "list-ol",
            event = events.GROUP.MAIN,
        },
        {
            title = "Past [Category] Runs",
            description = "Browse categories which have past runs associated with them",
            icon = "layer-group",
            event = events.CATEGORY.MAIN,
        },
        {
            title = "Past Run Settings",
            description = "Coming Soon (tm)",
            icon = "trademark",
            disabled = true,
        },
    }

    return out
end

function UI.ContextMenuOptions.PastRuns.Group.GetMainContextMenuOptions()
    local events = EVENTS.CLIENT.CONTEXT.PAST_RUNS.GROUP

    local playerData = Utils.GetPlayerData()
    local groups = lib.callback.await(
        CALLBACKS.SERVER.SPEED_TEST.GET_GROUPS_WITH_RUNS,
        false,
        playerData.citizenid
    )

    local out = {}

    for i, group in ipairs(groups) do
        table.insert(out, {
            title = group.Name,
            description = ("Group '%s' with %s vehicles"):format(
                group.Name,
                #group.VehicleNames
            ),
            icon = "minus",
            event = events.SELECT_GROUP,
            args = {
                group = group,
            }
        })
    end

    return out
end

function UI.ContextMenuOptions.PastRuns.Group.GetIndividualGroupContextMenuOptions(group)
    local out = {}

    local speedTests = lib.callback.await(
        CALLBACKS.SERVER.SPEED_TEST.GET_RUNS_FOR_GROUP_ID,
        false,
        group.Id
    )

    for i, speedTest in ipairs(speedTests) do
        local results = speedTest.Results
        local description = (results == nil or #results == 0)
            and "No tests were completed"
            or ("%s tests were completed.%s"):format(
                #results,
                speedTest.WasCancelled and " [Was Cancelled]" or ""
            )

        table.insert(out, {
            title = speedTest.TimeCreated,
            description = description,
            icon = "minus",
            event = EVENTS.CLIENT.CONTEXT.PAST_RUNS.GROUP.SELECT_TEST.MAIN,
            args = {
                test = speedTest,
            }
        })
    end

    return out
end

function UI.ContextMenuOptions.PastRuns.Group.GetInvidualTestContextMenuOptions(test)
    return {
        {
            title = "View Results",
            description = "View the results of this speed test",
            icon = "square-poll-vertical",
            event = EVENTS.CLIENT.CONTEXT.PAST_RUNS.GROUP.SELECT_TEST.VIEW_RESULTS,
            args = {
                test = test,
            },
        },
        {
            title = "Delete Test",
            description = "Remove this speed test from the list",
            icon = "trash",
            event = EVENTS.CLIENT.CONTEXT.PAST_RUNS.GROUP.SELECT_TEST.DELETE,
            args = {
                test = test,
            },
        },
    }
end

function UI.ContextMenuOptions.PastRuns.Category.GetMainContextMenuOptions()
    local events = EVENTS.CLIENT.CONTEXT.PAST_RUNS.CATEGORY

    local playerData = Utils.GetPlayerData()
    local categories = lib.callback.await(
        CALLBACKS.SERVER.SPEED_TEST.GET_CATEGORIES_WITH_RUNS,
        false,
        playerData.citizenid
    )

    local out = {}

    for i, categoryName in ipairs(categories) do
        local label = Config.VehicleCategories[categoryName]
        local categoryVehicles = SharedConfig.Vehicles[categoryName]

        if label == nil or categoryVehicles == nil then
            if SharedConfig.Debug then
                print(("Skipping unknown category (%s)"):format(categoryName))
            end

            -- Skip this one
            goto Skip
        end

        table.insert(out, {
            title = label,
            description = ("Category '%s' with %s vehicles"):format(
                label,
                #categoryVehicles
            ),
            icon = "minus",
            event = events.SELECT_CATEGORY,
            args = {
                label = label,
                categoryName = categoryName,
            }
        })

        :: Skip ::
    end

    return out
end

function UI.ContextMenuOptions.PastRuns.Category.GetIndividualCategoryContextMenuOptions(categoryName)
    local out = {}

    local speedTests = lib.callback.await(
        CALLBACKS.SERVER.SPEED_TEST.GET_RUNS_FOR_CATEGORY_NAME,
        false,
        categoryName
    )

    for i, speedTest in ipairs(speedTests) do
        local results = speedTest.Results
        local description = (results == nil or #results == 0)
            and "No tests were completed"
            or ("%s tests were completed.%s"):format(
                #results,
                speedTest.WasCancelled and " [Was Cancelled]" or ""
            )

        table.insert(out, {
            title = speedTest.TimeCreated,
            description = description,
            icon = "minus",
            event = EVENTS.CLIENT.CONTEXT.PAST_RUNS.GROUP.SELECT_TEST.MAIN,
            args = {
                test = speedTest,
            }
        })
    end

    return out
end