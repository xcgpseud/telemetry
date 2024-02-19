SpeedTestService = {}

function SpeedTestService.CreateNewSpeedTest(
    citizenId,
    groupId,
    categoryName,
    results,
    wasCancelled
)
    local entity = SpeedTestEntity:New(
        -1,
        citizenId,
        groupId,
        categoryName,
        results,
        wasCancelled
    )

    return SpeedTestRepository.Create(entity)
end

function SpeedTestService.AddValidVehiclesToGroup(groupId, vehicles)
    local toAdd = {}

    for _, vehicle in ipairs(vehicles) do
        if QBCore.Shared.Vehicles[vehicle] ~= nil then
            table.insert(toAdd, vehicle)
        end
    end

    return GroupRepository.AddVehiclesToGroup(groupId, toAdd), #toAdd
end