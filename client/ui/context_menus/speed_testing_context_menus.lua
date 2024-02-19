UI.ContextMenus.SpeedTesting = {}

function UI.ContextMenus.SpeedTesting.OpenSpeedTestMainContextMenu()
    local options = UI.ContextMenuOptions.SpeedTesting.GetSpeedTestMainContextMenuOptions()

    Utils.DisplayContext({
        id = MENUS.SPEED_TESTING.MAIN,
        title = "Speed Testing",
        options = options,
        menu = MENUS.MAIN,
    })
end

function UI.ContextMenus.SpeedTesting.OpenAutomatedGroupTestingContextMenu()
    local options = UI.ContextMenuOptions.SpeedTesting.GetGroupAutomaticTestingOptions()

    Utils.DisplayContext({
        id = MENUS.SPEED_TESTING.GROUP_AUTOMATIC_TESTING.MAIN,
        title = "Automatic Group Testing",
        options = options,
        menu = MENUS.SPEED_TESTING.MAIN,
    })
end

function UI.ContextMenus.SpeedTesting.OpenAutomatedCategoryTestingContextMenu()
    local options = UI.ContextMenuOptions.SpeedTesting.GetCategoryAutomaticTestingOptions(
        EVENTS.CLIENT.CONTEXT.SPEED_TESTING.AUTOMATED_CATEGORY.SELECT
    )

    Utils.DisplayContext({
        id = MENUS.SPEED_TESTING.CATEGORY_AUTOMATIC_TESTING,
        title = "Automatic Category Testing",
        options = options,
        menu = MENUS.SPEED_TESTING.MAIN,
    })
end

function UI.ContextMenus.SpeedTesting.OpenGroupAddVehiclesSelectCategoryContextMenu(groupId)
    local options = UI.ContextMenuOptions.SpeedTesting.GetCategoryAutomaticTestingOptions(
        EVENTS.CLIENT.CONTEXT.SPEED_TESTING.AUTOMATED_GROUP.GROUP.ADD_VEHICLES.BROWSE_CATEGORIES.SELECT_CATEGORY
    )

    Utils.DisplayContext({
        id = MENUS.SPEED_TESTING.GROUP_AUTOMATIC_TESTING.ADD_VEHICLES.BROWSE_CATEGORIES,
        title = "Browse Categories",
        options = options,
        menu = MENUS.SPEED_TESTING.GROUP_AUTOMATIC_TESTING.ADD_VEHICLES.MAIN
    })
end

function UI.ContextMenus.SpeedTesting.OpenGroupOptionsContextMenu(groupId)
    local options = UI.ContextMenuOptions.SpeedTesting.GetGroupOptionsContextMenuOptions(groupId)

    Utils.DisplayContext({
        id = MENUS.SPEED_TESTING.GROUP_AUTOMATIC_TESTING.SELECT,
        title = "Group Options",
        options = options,
        menu = MENUS.SPEED_TESTING.GROUP_AUTOMATIC_TESTING.MAIN,
    })
end

function UI.ContextMenus.SpeedTesting.OpenGroupAddVehiclesMainContextMenu(groupId)
    local options = UI.ContextMenuOptions.SpeedTesting.GetGroupCategoryList(groupId)

    Utils.DisplayContext({
        id = MENUS.SPEED_TESTING.GROUP_AUTOMATIC_TESTING.ADD_VEHICLES.BROWSE_CATEGORIES,
        title = "Browse Categories",
        options = options,
        menu = MENUS.SPEED_TESTING.GROUP_AUTOMATIC_TESTING.ADD_VEHICLES.MAIN,
    })
end

function UI.ContextMenus.SpeedTesting.OpenAddVehiclesToGroupMainMenu(groupId)
    local options = UI.ContextMenuOptions.SpeedTesting.GetAddVehiclesMainMenuOptions(groupId)

    Utils.DisplayContext({
        id = MENUS.SPEED_TESTING.GROUP_AUTOMATIC_TESTING.ADD_VEHICLES.MAIN,
        title = "Add vehicles to group",
        options = options,
        menu = MENUS.SPEED_TESTING.GROUP_AUTOMATIC_TESTING.SELECT,
    })
end


-- old --

function UI.ContextMenus.SpeedTesting.OpenAutomaticContextMenu()
    local options = UI.ContextMenuOptions.SpeedTesting.GetAutomaticSpeedTestContextMenuOptions()

    if options == nil or #options == 0 then
        Utils.NotifyPlayer("Failed to get options")
        return
    end

    lib.registerContext({
        id = MENUS.SpeedTest.Automatic,
        title = "Automatic Speed Test Options",
        options = options,
        menu = MENUS.SpeedTest.Main,
    })

    Wait(100)

    lib.showContext(MENUS.SpeedTest.Automatic)
end

function UI.ContextMenus.SpeedTesting.OpenManualContextMenu()
    local options = UI.ContextMenuOptions.SpeedTesting.GetManualSpeedTestContextMenuOptions()

    if options == nil or #options == 0 then
        Utils.NotifyPlayer("Failed to get options")
        return
    end

    lib.registerContext({
        id = MENUS.SpeedTest.Manual,
        title = "Manual Speed Test Options",
        options = options,
        menu = MENUS.SpeedTest.Main,
    })

    Wait(100)

    lib.showContext(MENUS.SpeedTest.Manual)
end

function UI.ContextMenus.SpeedTesting.OpenCategoryContextMenu()
    local options = UI.ContextMenuOptions.SpeedTesting.GetCategoryContextMenuOptions()

    if options == nil or #options == 0 then
        Utils.NotifyPlayer("failed to get options")
        return
    end

    lib.registerContext({
        id = MENUS.SpeedTest.Category,
        title = "Category Speed Test Options",
        options = options,
        menu = MENUS.SpeedTest.Automatic,
    })

    Wait(100)

    lib.showContext(MENUS.SpeedTest.Category)
end

function UI.ContextMenus.SpeedTesting.OpenGroupContextMenu()
    local options = UI.ContextMenuOptions.SpeedTesting.GetGroupContextMenuOptions()

    if options == nil or #options == 0 then
        Utils.NotifyPlayer("failed to get options")
        return
    end

    lib.registerContext({
        id = MENUS.SpeedTest.Group,
        title = "Group Test Options",
        options = options,
        menu = MENUS.SpeedTest.Automatic,
    })

    Wait(100)

    lib.showContext(MENUS.SpeedTest.Group)
end
