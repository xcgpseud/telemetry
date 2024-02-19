MigrationRepository = {}

function MigrationRepository.CheckIfTableExists(tableName)
    local result = MySQL.single.await(MigrationQueries.CheckIfTableExists, {
        ["@tableName"] = tableName
    })

    return result.table_exists == 1
end

function MigrationRepository.CreateTablesIfNotExists()
    local createSpeedTestsResult = MySQL.query.await(MigrationQueries.CreateSpeedTestsTable)
    local createGroupsResult = MySQL.query.await(MigrationQueries.CreateGroupsTable)

    if SharedConfig.Debug then
        print(
            "Created tables",
            json.encode(createSpeedTestsResult, {pretty = true}),
            json.encode(createGroupsResult, {pretty = true})
        )
    end
end