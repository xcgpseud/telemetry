UI.ContextMenus.PastRuns = {
    Group = {},
    Category = {},
}

function UI.ContextMenus.PastRuns.OpenMainContextMenu()
    local options = UI.ContextMenuOptions.PastRuns.GetMainContextMenuOptions()

    Utils.DisplayContext({
        id = MENUS.PAST_RUNS.MAIN,
        title = "Past Runs",
        options = options,
        menu = MENUS.MAIN,
    })
end

function UI.ContextMenus.PastRuns.Group.OpenMainContextMenu()
    local options = UI.ContextMenuOptions.PastRuns.Group.GetMainContextMenuOptions()

    Utils.DisplayContext({
        id = MENUS.PAST_RUNS.GROUP.MAIN,
        title = "Past Group Runs",
        options = options,
        menu = MENUS.PAST_RUNS.MAIN,
    })
end

function UI.ContextMenus.PastRuns.Group.OpenIndividualGroupContextMenu(group)
    local options = UI.ContextMenuOptions.PastRuns.Group.GetIndividualGroupContextMenuOptions(group)

    Utils.DisplayContext({
        id = MENUS.PAST_RUNS.GROUP.SPEED_TESTS,
        title = ("Group [%s] Speed Tests"):format(group.Name),
        options = options,
        menu = MENUS.PAST_RUNS.GROUP.MAIN,
    })
end

function UI.ContextMenus.PastRuns.Group.OpenIndividualTestContextMenu(speedTest)
    local options = UI.ContextMenuOptions.PastRuns.Group.GetInvidualTestContextMenuOptions(speedTest)

    Utils.DisplayContext({
        id = MENUS.PAST_RUNS.GROUP.OPTIONS,
        title = ("[%s] test Options"):format(speedTest.TimeCreated),
        options = options,
        menu = MENUS.PAST_RUNS.GROUP.SPEED_TESTS,
    })
end

function UI.ContextMenus.PastRuns.Category.OpenMainContextMenu()
    local options = UI.ContextMenuOptions.PastRuns.Category.GetMainContextMenuOptions()

    Utils.DisplayContext({
        id = MENUS.PAST_RUNS.CATEGORY.MAIN,
        title = "Past Category Runs",
        options = options,
        menu = MENUS.PAST_RUNS.MAIN,
    })
end

function UI.ContextMenus.PastRuns.Category.OpenIndividualCategoryContextMenu(categoryName)
    local options = UI.ContextMenuOptions.PastRuns.Category.GetIndividualCategoryContextMenuOptions(categoryName)

    Utils.DisplayContext({
        id = MENUS.PAST_RUNS.CATEGORY.SPEED_TESTS,
        title = "Past Tests in this Category",
        options = options,
        menu = MENUS.PAST_RUNS.CATEGORY.MAIN,
    })
end