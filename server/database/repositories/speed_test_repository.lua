SpeedTestRepository = {}

function SpeedTestRepository.Create(speedTestEntity)
    local id = MySQL.insert.await([[
        INSERT INTO telemetry_speed_tests (
            citizen_id,
            group_id,
            category_name,
            results_json,
            was_cancelled,
            is_deleted
        ) VALUES (
            @citizenId,
            @groupId,
            @categoryName,
            @resultsJson,
            @wasCancelled,
            @isDeleted
        )
    ]], {
        ["@citizenId"] = speedTestEntity.CitizenId,
        ["@groupId"] = speedTestEntity.GroupId,
        ["@categoryName"] = speedTestEntity.CategoryName,
        ["@resultsJson"] = json.encode(speedTestEntity.Results),
        ["@wasCancelled"] = speedTestEntity.WasCancelled,
        ["@isDeleted"] = speedTestEntity.IsDeleted,
    })

    return SpeedTestRepository.GetById(id)
end

function SpeedTestRepository.GetById(id)
    local result = MySQL.single.await([[
        SELECT
            id,
            citizen_id,
            group_id,
            category_name,
            results_json,
            was_cancelled,
            is_deleted,
            DATE_FORMAT(time_created, '%D %b %Y at %H:%i')
        FROM telemetry_speed_tests
        WHERE id = @id
    ]], {
        ["@id"] = id,
    })

    return SpeedTestEntity.CreateFromDatabaseResult(result)
end

function SpeedTestRepository.GetAllByGroupID(groupId)
    local results = MySQL.query.await([[
        SELECT
            id,
            citizen_id,
            group_id,
            category_name,
            results_json,
            was_cancelled,
            is_deleted,
            DATE_FORMAT(time_created, '%D %b %Y at %H:%i') AS time_created
        FROM telemetry_speed_tests
        WHERE   group_id = @groupId
        AND     is_deleted = 0
    ]], {
        ["@groupId"] = groupId,
    })

    local out = {}
    for _, result in ipairs(results) do
        table.insert(out, SpeedTestEntity.CreateFromDatabaseResult(result))
    end

    return out
end

function SpeedTestRepository.GetAllBy(keyValues, outFunc)
    local segments = {}
    local bindings = {}
    for key, value in pairs(keyValues) do
        table.insert(segments, ("%s = %s"):format(key, ("@%s"):format(key)))
        bindings[("@%s"):format(key)] = value
    end

    local query = [[
        SELECT
            id,
            citizen_id,
            group_id,
            category_name,
            results_json,
            was_cancelled,
            is_deleted,
            DATE_FORMAT(time_created, '%D %b %Y at %H:%i') AS time_created
        FROM    telemetry_speed_tests
        WHERE 
    ]] .. table.concat(segments, " AND ") .. [[
        AND is_deleted = 0
    ]]

    local results = MySQL.query.await(query, bindings)

    if outFunc == nil then
        return results
    end

    local out = {}
    for _, row in ipairs(results) do
        table.insert(out, outFunc(row))
    end

    return out
end

function SpeedTestRepository.GetGroupsWithAssociatedRunsForCitizenId(citizenId)
    local results = MySQL.query.await([[
        SELECT
            tg.id AS id,
            tg.citizen_id as citizen_id,
            tg.name AS name,
            tg.vehicle_names AS vehicle_names
        FROM
            telemetry_speed_tests AS tst
        LEFT JOIN
            telemetry_groups AS tg
        ON  tst.group_id = tg.id
        WHERE
            tst.citizen_id = @citizenId
        AND tg.is_deleted = 0
        AND tst.is_deleted = 0
        GROUP BY
            tst.group_id
        ORDER BY tg.name ASC
    ]], {
        ["@citizenId"] = citizenId,
    })

    local out = {}
    for _, result in ipairs(results) do
        table.insert(out, GroupEntity.CreateFromResult(result))
    end

    return out
end

function SpeedTestRepository.GetCategoriesWithAssociatedRunsForCitizenId(citizenId)
    local results = MySQL.query.await([[
        SELECT  category_name
        FROM    telemetry_speed_tests
        WHERE   citizen_id = @citizenId
        AND     category_name IS NOT NULL
        AND     category_name <> ''
        AND     is_deleted = 0
        GROUP BY
                category_name
        ORDER BY
                category_name ASC
    ]], {
        ["@citizenId"] = citizenId,
    })

    local out = {}
    for _, result in ipairs(results) do
        table.insert(out, result.category_name)
    end

    return out
end

function SpeedTestRepository.DeleteSpeedTest(speedTestId)
    local affectedRows = MySQL.update.await([[
        UPDATE  telemetry_speed_tests
        SET     is_deleted = 1
        WHERE   id = @speedTestId
    ]], {
        ["@speedTestId"] = speedTestId,
    })

    return affectedRows > 0
end