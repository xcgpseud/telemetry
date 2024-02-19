SpeedTestEntity = {}

local function _New(
    id,
    citizenId,
    groupId,
    categoryName,
    results,
    wasCancelled,
    isDeleted,
    timeCreated
)
    if results == nil then
        results = "{}"
    end
    results = type(results) == "string" and json.decode(results) or results

    return {
        Id = id or -1,
        CitizenId = citizenId,
        GroupId = groupId or -1,
        CategoryName = categoryName or "",
        Results = results,
        WasCancelled = wasCancelled or false,
        IsDeleted = isDeleted or false,
        TimeCreated = timeCreated or nil
    }
end

function SpeedTestEntity:New(
    id,
    citizenId,
    groupId,
    categoryName,
    results,
    wasCancelled,
    isDeleted,
    timeCreated
)
    local o = _New(
        id,
        citizenId,
        groupId,
        categoryName,
        results,
        wasCancelled,
        isDeleted,
        timeCreated
    )

    setmetatable(o, self)
    self.__index = self

    return o
end

function SpeedTestEntity.CreateFromDatabaseResult(result)
    return SpeedTestEntity:New(
        result.id,
        result.citizen_id,
        result.group_id,
        result.category_name,
        result.results_json,
        result.was_cancelled,
        result.is_deleted,
        result.time_created
    )
end
