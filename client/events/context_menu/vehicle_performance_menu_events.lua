local events = EVENTS.CLIENT.CONTEXT.VEHICLE_PERFORMANCE

-- VEHICLE PERFORMANCE MENU EVENTS --

RegisterNetEvent(events.MAIN, function(args)
    UI.ContextMenus.OpenVehiclePerformanceMainContextMenu()
end)

-- Performance Upgrades --
RegisterNetEvent(events.PERFORMANCE_UPGRADES.MAIN, function(args)
    UI.ContextMenus.OpenVehiclePerformanceUpgradeMainContextMenu()
end)

-- Fix vehicle
RegisterNetEvent(events.FIX_VEHICLE, function()
    PerformanceService.FixVehicle()
end)

-- Toggle drift mode
RegisterNetEvent(events.TOGGLE_DRIFT_MODE, function(args)
    PerformanceService.ToggleDriftMode(PerformanceService.GetVehicle())
end)

-- PERFORMANCE UPGRADES MENU EVENTS --
RegisterNetEvent(events.PERFORMANCE_UPGRADES.SELECT_UPGRADES, function(args)
    UI.Dialogues.Performance.EditUpgrades()
end)

-- Enable all (except armour)
RegisterNetEvent(events.PERFORMANCE_UPGRADES.ENABLE_ALL_EXCEPT_ARMOUR, function(args)
    PerformanceService.SetAllPerformanceMods(nil, true)
end)

-- Disable all (except armour)
RegisterNetEvent(events.PERFORMANCE_UPGRADES.DISABLE_ALL_EXCEPT_ARMOUR, function(args)
    PerformanceService.SetAllPerformanceMods(nil, false)
end)
