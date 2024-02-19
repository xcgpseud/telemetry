local events = EVENTS.CLIENT.CONTEXT.SPEED_TESTING

-- Main speed testing menu events
RegisterNetEvent(events.MAIN, function()
    UI.ContextMenus.SpeedTesting.OpenSpeedTestMainContextMenu()
end)

RegisterNetEvent(events.AUTOMATED_GROUP.MAIN, function()
    UI.ContextMenus.SpeedTesting.OpenAutomatedGroupTestingContextMenu()
end)

RegisterNetEvent(events.AUTOMATED_CATEGORY.MAIN, function()
    UI.ContextMenus.SpeedTesting.OpenAutomatedCategoryTestingContextMenu()
end)

RegisterNetEvent(events.MANUAL_SINGLE, function()
    SpeedTestService.BeginManualSpeedTest()
end)

RegisterNetEvent(events.CANCEL_ONGOING, function()
    Context.SpeedTest.IsRunning = false
    Utils.NotifyPlayer("Test ended; if one is still ongoing, please wait for it to complete.")
end)
-- AUTOMATED GROUP MENU EVENTS --

-- When clicking on a group
RegisterNetEvent(events.AUTOMATED_GROUP.GROUP.MAIN, function(args)
    UI.ContextMenus.SpeedTesting.OpenGroupOptionsContextMenu(args.group.Id)
end)

-- Create New Group
RegisterNetEvent(events.AUTOMATED_GROUP.CREATE_NEW, function()
    UI.Dialogues.SpeedTest.CreateGroupDialogue()
end)

-- [1] - Run the tests on these cars
RegisterNetEvent(events.AUTOMATED_GROUP.GROUP.EXECUTE_AUTOMATIC_TEST, function(args)
    SpeedTestService.BeginAutomatedGroupTest(args.groupId)
end)

-- [1] - Add vehicles to group - [1.1]
RegisterNetEvent(events.AUTOMATED_GROUP.GROUP.ADD_VEHICLES.MAIN, function(args)
    UI.ContextMenus.SpeedTesting.OpenAddVehiclesToGroupMainMenu(args.groupId)
end)

-- [1.1] Browse categories
RegisterNetEvent(events.AUTOMATED_GROUP.GROUP.ADD_VEHICLES.BROWSE_CATEGORIES.MAIN, function(args)
    UI.ContextMenus.SpeedTesting.OpenGroupAddVehiclesMainContextMenu(args.groupId)
end)

-- [1.1] - Type vehicle names manually
RegisterNetEvent(events.AUTOMATED_GROUP.GROUP.ADD_VEHICLES.TYPE_NAMES, function(args)
    UI.Dialogues.ShowAddVehiclesToGroupDialogue(args.groupId)
end)

-- [1] - Browse group vehicles
RegisterNetEvent(events.AUTOMATED_GROUP.GROUP.BROWSE_VEHICLES, function(args)
    UI.Dialogues.SpeedTest.EditGroupVehicles(args.groupId)
end)

-- [1] - Delete group
RegisterNetEvent(events.AUTOMATED_GROUP.GROUP.DELETE, function(args)
    SpeedTestService.DeleteGroup(args.groupId)
end)

-- AUTOMATED CATEGORY MENU EVENTS --

-- Each group in list
RegisterNetEvent(events.AUTOMATED_CATEGORY.SELECT, function(args)
    SpeedTestService.BeginCategoryTest(args.category)
end)

-- Cancel ongoing test
RegisterNetEvent(events.CANCEL_ONGOING, function(args)
    SpeedTestService.CancelOngoingTests()
end)