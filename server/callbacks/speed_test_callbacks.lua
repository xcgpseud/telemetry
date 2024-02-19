local callbacks = CALLBACKS.SERVER.SPEED_TEST

lib.callback.register(
    callbacks.GROUP.CREATE_GROUP,
    function(_, groupName, citizenId)
        local group = GroupRepository.CreateGroup(groupName, citizenId)
        return group
    end
)

lib.callback.register(
    callbacks.GROUP.ADD_VEHICLES_TO_GROUP,
    function(_, groupId, vehicles)
        return SpeedTestService.AddValidVehiclesToGroup(groupId, vehicles)
    end
)

lib.callback.register(
    callbacks.GROUP.GET_ALL_GROUPS,
    function(_, citizenId)
        local groups = GroupRepository.GetAllGroupsForPlayer(citizenId)
        return groups
    end
)

lib.callback.register(
    callbacks.GROUP.GET_GROUP_BY_ID,
    function(_, groupId)
        return GroupRepository.GetGroupById(groupId)
    end
)

lib.callback.register(callbacks.GROUP.UPDATE_GROUP, function(_, group)
    return GroupRepository.UpdateGroup(group)
end)

lib.callback.register(callbacks.GROUP.RENAME_GROUP, function(_, groupId, newName)
    return GroupRepository.RenameGroup(groupId, newName)
end)

lib.callback.register(callbacks.GROUP.DELETE_GROUP, function(_, groupId)
    return GroupRepository.DeleteGroup(groupId)
end)

lib.callback.register(callbacks.SAVE_RUN, function(
    _,
    citizenId,
    groupId,
    categoryName,
    results,
    wasCancelled
)
    return SpeedTestService.CreateNewSpeedTest(
        citizenId,
        groupId,
        categoryName,
        results,
        wasCancelled
    )
end)

lib.callback.register(callbacks.GET_CATEGORIES_WITH_RUNS, function(_, citizenId)
    return SpeedTestRepository.GetCategoriesWithAssociatedRunsForCitizenId(citizenId)
end)

lib.callback.register(callbacks.GET_GROUPS_WITH_RUNS, function(_, citizenId)
    return SpeedTestRepository.GetGroupsWithAssociatedRunsForCitizenId(citizenId)
end)

lib.callback.register(callbacks.GET_RUNS_FOR_GROUP_ID, function(_, groupId)
    -- return SpeedTestRepository.GetAllByGroupID(groupId)
    return SpeedTestRepository.GetAllBy(
        {
            group_id = groupId,
        },
        function(row)
            return SpeedTestEntity.CreateFromDatabaseResult(row)
        end
    )
end)

lib.callback.register(callbacks.GET_RUNS_FOR_CATEGORY_NAME, function(_, categoryName)
    return SpeedTestRepository.GetAllBy(
        {
            category_name = categoryName,
        },
        function(row)
            return SpeedTestEntity.CreateFromDatabaseResult(row)
        end
    )
end)

lib.callback.register(callbacks.DELETE_TEST, function(_, testId)
    return SpeedTestRepository.DeleteSpeedTest(testId)
end)

lib.callback.register(CALLBACKS.SERVER.DOES_TABLE_EXIST, function(_, tableName)
    return MigrationRepository.CheckIfTableExists(tableName)
end)

lib.callback.register(CALLBACKS.SERVER.CREATE_TABLES, function()
    return MigrationRepository.CreateTablesIfNotExists()
end)