RegisterNetEvent(EVENTS.CLIENT.DIALOGUE.GROUP.CREATE, function()
    UI.Dialogues.SpeedTest.CreateGroupDialogue()
end)

RegisterNetEvent(
    EVENTS.CLIENT.DIALOGUE.GROUP.ADD_VEHICLES_TO_GROUP.SELECT_FROM_CATEGORY,
    function(args)
        UI.Dialogues.SpeedTest.AddVehiclesFromCategoryToGroupDialogue(
            args.groupId,
            args.categoryLabel,
            args.vehicleList
        )
    end
)

RegisterNetEvent(
    EVENTS.CLIENT.DIALOGUE.GROUP.UPDATE_GROUP,
    function(args)
        return lib.callback.await(CALLBACKS.SERVER.SPEED_TEST.GROUP.UPDATE_GROUP, false, args.group)
    end
)