GroupRepository = {}

function GroupRepository.CreateGroup(name, citizenId)
    local sql = [[
        INSERT INTO telemetry_groups(
            name,
            citizen_id,
            vehicle_names
        ) VALUES (
            @name,
            @citizenId,
            '[]'
        )
    ]]

    local id = MySQL.insert.await(sql, {
        ["@name"] = name,
        ["@citizenId"] = citizenId,
    })

    return GroupEntity:New(id, name, citizenId)
end

---Add a list of vehicle models to the group
---@param groupId number
---@param vehicleModels table<string>
---@return number affectedRows The number of rows affected
function GroupRepository.AddVehiclesToGroup(groupId, vehicleModels)
    local group = GroupRepository.GetGroupById(groupId)

    if group == nil then
        return 0
    end

    local vehicles = group.VehicleNames

    for _, vehicleModel in ipairs(vehicleModels) do
        if not SharedUtils.ExistsInTable(vehicles, vehicleModel) then
            table.insert(vehicles, vehicleModel)
        end
    end

    local affectedRows = MySQL.update.await([[
        UPDATE telemetry_groups
        SET vehicle_names = @vehicleModels
        WHERE id = @groupId
    ]], {
        ["@vehicleModels"] = json.encode(vehicles),
        ["@groupId"] = groupId,
    })

    return affectedRows
end

function GroupRepository.GetAllGroupsForPlayer(playerCitizenId)
    local sql = [[
        SELECT *
        FROM telemetry_groups
        WHERE citizen_id = @citizenId
        AND is_deleted = 0
    ]]

    local results = MySQL.query.await(sql, {
        ["@citizenId"] = playerCitizenId,
    })

    local out = {}
    for _, result in ipairs(results) do
        table.insert(out, GroupEntity.CreateFromResult(result))
    end

    return out
end

function GroupRepository.GetGroupById(groupId)
    local sql = [[
        SELECT *
        FROM telemetry_groups
        WHERE id = @groupId
    ]]

    local row = MySQL.single.await(sql, {
        ["@groupId"] = groupId,
    })

    if not row then
        return nil
    end

    return GroupEntity.CreateFromResult(row)
end

function GroupRepository.UpdateGroup(group)
    return MySQL.update.await([[
        UPDATE telemetry_groups
        SET
            name = @name,
            vehicle_names = @vehicleNames
        WHERE
            id = @id
    ]], {
        ["@name"] = group.Name,
        ["@vehicleNames"] = json.encode(group.VehicleNames),
        ["@id"] = group.Id,
    }) > 0
end

function GroupRepository.RenameGroup(groupId, newName)
    return MySQL.update.await([[
        UPDATE telemetry_groups
        SET name = @name
        WHERE id = @id
    ]], {
        ["@name"] = newName,
        ["@id"] = groupId,
    }) > 0
end

function GroupRepository.DeleteGroup(groupId)
    return MySQL.update.await([[
        UPDATE telemetry_groups
        SET is_deleted = 1
        WHERE id = @id
    ]], {
        ["@id"] = groupId
    }) > 0
end