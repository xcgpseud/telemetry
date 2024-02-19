GroupEntity = {}

local function _New(id, name, citizenId, vehicleNames)
    vehicleNames = vehicleNames or {}

    return {
        Id = id,
        CitizenId = citizenId,
        Name = name,
        VehicleNames = vehicleNames,
        IsDeleted = false,
    }
end

function GroupEntity:New(id, name, citizenId, vehicleNames)
    vehicleNames = vehicleNames or {}

    local o = _New(id, name, citizenId, vehicleNames)

    setmetatable(o, self)
    self.__index = self

    return o
end

function GroupEntity.CreateFromResult(result)
    local vehicleNames = json.decode(result.vehicle_names)
    return GroupEntity:New(result.id, result.name, result.citizen_id, vehicleNames)
end
