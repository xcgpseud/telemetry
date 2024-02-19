PerformanceService = {}

function PerformanceService.GetVehicle()
    local player = PlayerPedId()
    return GetVehiclePedIsIn(player, false)
end

function PerformanceService.IsDriftModeEnabled(vehicle)
    return GetDriftTyresEnabled(vehicle)
end

function PerformanceService.ToggleDriftMode(vehicle)
    local isDriftModeEnabled = not PerformanceService.IsDriftModeEnabled(vehicle)

    SetDriftTyresEnabled(vehicle, isDriftModeEnabled)
    Utils.NotifyPlayer(("Drift mode %s"):format(isDriftModeEnabled and "enabled" or "disabled"))
end

function PerformanceService.GetCurrentVehicleUpgrades(vehicle)
    vehicle = vehicle or PerformanceService.GetVehicle()

    local modsToCheck = SharedConfig.AllMods

    local results = {}

    for _, mod in ipairs(modsToCheck) do
        local currentModIndex = GetVehicleMod(vehicle, mod.typeId)
        local maxModIndex = GetNumVehicleMods(vehicle, mod.typeId)

        table.insert(results, {
            current = currentModIndex,
            max = maxModIndex,
            mod = mod,
        })
    end

    return results
end

function PerformanceService.FixVehicle(vehicle)
    if Config.Custom.FixVehicleFunction == nil then
        TriggerEvent('iens:repaira')
        TriggerEvent('vehiclemod:client:fixEverything')
    else
        Config.Custom.FixVehicleFunction(vehicle)
    end
end

function PerformanceService.SetAllPerformanceMods(vehicle, enabled)
    local wait = 200

    Utils.NotifyPlayer("Upgrading vehicle, please wait...")

    vehicle = vehicle or PerformanceService.GetVehicle()
    SetVehicleModKit(vehicle, 0)
    Wait(wait)

    for _, mod in ipairs(SharedConfig.PerformanceMods) do
        if mod.toggle then
            ToggleVehicleMod(vehicle, mod.typeId, enabled)
        else
            local maxModIndex = GetNumVehicleMods(vehicle, mod.typeId) - 1
            if SharedUtils.KeyExists(mod, "reduce") then
                maxModIndex = maxModIndex - mod.reduce
            end

            SetVehicleMod(
                vehicle,
                mod.typeId,
                enabled
                    and maxModIndex
                    or 0
                )
        end
        Wait(wait)
    end

    Utils.NotifyPlayer(("%s all upgrades"):format(enabled and "Enabled" or "Disabled"))
end

function PerformanceService.GetModInfo(modTypeId, vehicle)
    vehicle = vehicle or PerformanceService.GetVehicle()

    local currentModIndex = GetVehicleMod(vehicle, modTypeId)
    local maxModIndex = GetNumVehicleMods(vehicle, modTypeId) - 1

    local mod = SharedUtils.Filter(VehicleMods.mods, function(x)
        return x.typeId == modTypeId
    end)

    if mod == nil or #mod == 0 then
        mod = {}
    end

    return {
        current = currentModIndex,
        max = maxModIndex,
        mod = mod,
    }
end

function PerformanceService.GetModIndexes(modTypeId, vehicle)
    vehicle = vehicle or PerformanceService.GetVehicle()
    SetVehicleModKit(vehicle, 0)

    return GetVehicleMod(vehicle, modTypeId), GetNumVehicleMods(vehicle, modTypeId)
end

function PerformanceService.ToggleArmour(vehicle)
    vehicle = vehicle or PerformanceService.GetVehicle()
    SetVehicleModKit(vehicle, 0)

    local armor = VehicleMods.mods.armor
    local current, max = PerformanceService.GetModIndexes(armor.typeId, vehicle)

    if current == -1 then
        SetVehicleMod(vehicle, armor.typeId, max)
        Utils.NotifyPlayer("Enabling Armour")
    else
        SetVehicleMod(vehicle, armor.typeId, 0)
        Utils.NotifyPlayer("Disabling Armour")
    end
end