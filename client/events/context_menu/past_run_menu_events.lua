RegisterNetEvent(EVENTS.CLIENT.CONTEXT.PAST_RUNS.MAIN, function()
    UI.ContextMenus.PastRuns.OpenMainContextMenu()
end)

RegisterNetEvent(EVENTS.CLIENT.CONTEXT.PAST_RUNS.GROUP.MAIN, function()
    UI.ContextMenus.PastRuns.Group.OpenMainContextMenu()
end)

RegisterNetEvent(EVENTS.CLIENT.CONTEXT.PAST_RUNS.GROUP.SELECT_GROUP, function(args)
    UI.ContextMenus.PastRuns.Group.OpenIndividualGroupContextMenu(args.group)
end)

RegisterNetEvent(EVENTS.CLIENT.CONTEXT.PAST_RUNS.CATEGORY.MAIN, function()
    UI.ContextMenus.PastRuns.Category.OpenMainContextMenu()
end)

RegisterNetEvent(EVENTS.CLIENT.CONTEXT.PAST_RUNS.GROUP.SELECT_TEST.MAIN, function(args)
    UI.ContextMenus.PastRuns.Group.OpenIndividualTestContextMenu(args.test)
end)

RegisterNetEvent(EVENTS.CLIENT.CONTEXT.PAST_RUNS.GROUP.SELECT_TEST.VIEW_RESULTS, function(args)
    UI.Dialogues.SpeedTest.DisplayLargeResults(args.test.Results)
end)

RegisterNetEvent(EVENTS.CLIENT.CONTEXT.PAST_RUNS.GROUP.SELECT_TEST.DELETE, function(args)
    local isDeleted = lib.callback.await(
        CALLBACKS.SERVER.SPEED_TEST.DELETE_TEST,
        false,
        args.test.Id
    )

    if SharedConfig.Debug and not isDeleted then
        print(("Failed to delete Speed Test with ID of %s"):format(args.test.Id))
    end

    Utils.NotifyPlayer(isDeleted and "Deleted Test" or "Failed to delete test")
end)

RegisterNetEvent(EVENTS.CLIENT.CONTEXT.PAST_RUNS.CATEGORY.SELECT_CATEGORY, function(args)
    UI.ContextMenus.PastRuns.Category.OpenIndividualCategoryContextMenu(args.categoryName)
end)