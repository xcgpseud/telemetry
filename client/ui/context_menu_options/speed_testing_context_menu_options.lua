UI.ContextMenuOptions.SpeedTesting = {
    Group = {},
}

function UI.ContextMenuOptions.SpeedTesting.GetSpeedTestMainContextMenuOptions()
    local events = EVENTS.CLIENT.CONTEXT.SPEED_TESTING
    return {
        {
            title = "[GROUP] Automatic Testing",
            description = "Automatic testing centred around manually created groups",
            icon = "list-ol",
            event = events.AUTOMATED_GROUP.MAIN,
        },
        {
            title = "[CATEGORY] Automatic Testing",
            description = "Automatic testing centred around in-game vehicle categories",
            icon = "layer-group",
            event = events.AUTOMATED_CATEGORY.MAIN,
        },
        {
            title = "Manual Test",
            description = "Begin a manual test in your current vehicle",
            icon = "car-side",
            event = events.MANUAL_SINGLE,
        },
        {
            title = "Cancel Ongoing Test",
            description = "Cancel any ongoing tests, regardless of which type",
            icon = "xmark",
            event = events.CANCEL_ONGOING,
        },
    }
end

function UI.ContextMenuOptions.SpeedTesting.GetGroupAutomaticTestingOptions()
    local callbacks = CALLBACKS.SERVER.SPEED_TEST.GROUP

    local out = {
        {
            title = "Create New Group",
            description = "Create a new custom group of vehicles for testing",
            icon = "plus",
            event = EVENTS.CLIENT.CONTEXT.SPEED_TESTING.AUTOMATED_GROUP.CREATE_NEW,
        },
    }

    local citizenId = QBCore.Functions.GetPlayerData().citizenid
    local groups = lib.callback.await(callbacks.GET_ALL_GROUPS, false, citizenId)

    for key, group in ipairs(groups) do
        table.insert(out, {
            title = group.Name,
            description = ("Currently has %s vehicles"):format(#group.VehicleNames),
            icon = "minus",
            event = EVENTS.CLIENT.CONTEXT.SPEED_TESTING.AUTOMATED_GROUP.GROUP.MAIN,
            args = {
                group = group,
            },
        })
    end

    return out
end

function UI.ContextMenuOptions.SpeedTesting.GetCategoryAutomaticTestingOptions(event)
    local out = {}

    local icons = SharedUtils.Alternate('x', 'o', #SharedUtils.TableValues(Config.VehicleCategories))

    local i = 1
    for key, label in pairs(Config.VehicleCategories) do
        table.insert(out, {
            title = label,
            description = ("Select the [%s] category"):format(label),
            icon = icons[i],
            event = event,
            args = {
                category = key,
                label = label,
            },
        })
        i = i + 1
    end

    return out
end

function UI.ContextMenuOptions.SpeedTesting.GetGroupCategoryList(groupId)
    local options = {}

    for category, vehicleList in pairs(SharedConfig.Vehicles) do
        local categoryLabel = Config.VehicleCategories[category]

        if categoryLabel == nil then
            goto Skip
        end

        table.insert(options, {
            title = categoryLabel,
            description = ("Select vehicles from the [%s] category"):format(categoryLabel),
            icon = "car-side",
            event = EVENTS.CLIENT.DIALOGUE.GROUP.ADD_VEHICLES_TO_GROUP.SELECT_FROM_CATEGORY,
            args = {
                groupId = groupId,
                categoryLabel = categoryLabel,
                vehicleList = vehicleList,
            },
        })

        :: Skip ::
    end

    return options
end

-- function UI.ContextMenuOptions.SpeedTest.GetAutomaticSpeedTestContextMenuOptions()
--     return {
--         {
--             title = "Category Speed Tests",
--             description = "Begin a Speed Test of a given vehicle category",
--             icon = "car-side",
--             event = EVENTS.CLIENT.CONTEXT.SPEED_TESTING.CATEGORY.MAIN,
--         },
--         {
--             title = "Group Speed Tests",
--             description = "Begin a Speed Test of a given vehicle group",
--             icon = "car-side",
--             event = EVENTS.CLIENT.CONTEXT.SPEED_TESTING.GROUP.MAIN,
--         },
--         {
--             title = "Run automatic speed test",
--             description = "Run an automatic speed test with this current vehicle.",
--             icon = "car-side",
--             event = EVENTS.CLIENT.SPEED_TEST.BEGIN_AUTOMATIC,
--         }
--     }
-- end

-- function UI.ContextMenuOptions.SpeedTest.GetManualSpeedTestContextMenuOptions()
--     return {
--         {
--             title = "Begin manual speed test",
--             description = "Begin a manual speed test.",
--             icon = "car-side",
--             event = EVENTS.CLIENT.SPEED_TEST.BEGIN_MANUAL,
--         },
--         {
--             title = "Cancel manual speed test",
--             description = "Cancel a speed test if one is running.",
--             icon = "car-side",
--             event = EVENTS.CLIENT.SPEED_TEST.CANCEL_MANUAL,
--         },
--     }
-- end

function UI.ContextMenuOptions.SpeedTesting.GetGroupOptionsContextMenuOptions(groupId)
    local out = {
        {
            title = "Execute speed test on all vehicles in group",
            description =
                "Execute a speed test on every vehicle in this group, "
                .. "results will be saved for future use.",
            icon = "gauge-high",
            event = EVENTS.CLIENT.CONTEXT.SPEED_TESTING.AUTOMATED_GROUP.GROUP.EXECUTE_AUTOMATIC_TEST,
            args = { groupId = groupId },
        },
        {
            title = "Add vehicles to group",
            description = "Various options to add vehicles to a group",
            icon = "plus",
            event = EVENTS.CLIENT.CONTEXT.SPEED_TESTING.AUTOMATED_GROUP.GROUP.ADD_VEHICLES.MAIN,
            args = { groupId = groupId },
        },
        {
            title = "Edit group",
            description = "View and edit the existing group and group vehicles",
            icon = "pencil",
            event = EVENTS.CLIENT.CONTEXT.SPEED_TESTING.AUTOMATED_GROUP.GROUP.BROWSE_VEHICLES,
            args = { groupId = groupId },
        },
        {
            title = "Delete group",
            description = "Remove this group from your list entirely",
            icon = "trash",
            event = EVENTS.CLIENT.CONTEXT.SPEED_TESTING.AUTOMATED_GROUP.GROUP.DELETE,
            args = { groupId = groupId },
        }
    }

    return out
end

function UI.ContextMenuOptions.SpeedTesting.GetAddVehiclesMainMenuOptions(groupId)
    return {
        {
            title = "Browse Vehicles",
            description = "Browse each vehicle category and add vehicles",
            icon = "magnifying-glass",
            event = EVENTS.CLIENT.CONTEXT.SPEED_TESTING.AUTOMATED_GROUP.GROUP.ADD_VEHICLES.BROWSE_CATEGORIES.MAIN,
            args = { groupId = groupId },
        },
        {
            title = "Type vehicle names manually",
            description = "Type a comma-separated list of vehicle models and we'll add the valid ones",
            icon = "font",
            event = EVENTS.CLIENT.CONTEXT.SPEED_TESTING.AUTOMATED_GROUP.GROUP.ADD_VEHICLES.TYPE_NAMES,
            args = { groupId = groupId },
        },
    }
end

-- function UI.ContextMenuOptions.SpeedTesting.Group.GetVehicleOptions(groupId, vehicleModel)
--     return {
--         -- {
--         --     title = "Add this vehicle to another group",
--         --     description = "Select another group to add this vehicle to",
--         -- }
--         {
--             title = "Remove from group",
--             descrption = "Remove this vehicle from the group",
--             icon = "trash",
--             event = EVENTS.CLIENT.CONTEXT.SPEED_TESTING.AUTOMATED_GROUP.GROUP.BROWSE_VEHICLES.REMOVE,
--             args = { groupId, vehicleModel },
--         },
--     }
-- end
