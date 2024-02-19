UI.ContextMenuOptions.VehiclePerformance = {}
local events = EVENTS.CLIENT.CONTEXT.VEHICLE_PERFORMANCE

function UI.ContextMenuOptions.VehiclePerformance.GetVehiclePerformanceContextMenuOptions()
    local vehicle = PerformanceService.GetVehicle()
    local isDriftModeEnabled = PerformanceService.IsDriftModeEnabled

    return {
        {
            title = "Performance Upgrades",
            description = "Manage your performance upgrades",
            icon = "wrench",
            event = events.PERFORMANCE_UPGRADES.MAIN,
        },
        {
            title = "Fix Vehicle",
            description = "Fix your vehicle!",
            icon = "hammer",
            event = events.FIX_VEHICLE,
        },
        {
            title = ("Toggle Drift Mode [%s]"):format(isDriftModeEnabled(vehicle) and "Enabled" or "Disabled"),
            description = "Try out some drift tyres and see how it handles!",
            icon = isDriftModeEnabled(vehicle) and "check" or "xmark",
            event = events.TOGGLE_DRIFT_MODE,
        },
    }
end

function UI.ContextMenuOptions.VehiclePerformance.GetVehiclePerformanceUpgradeContextMenuOptions()
    local vehicle = PerformanceService.GetVehicle()
    local enableCustom = Config.Custom.EnableCustomUpgradeAndDowngradeEvents

    local out = {
        {
            title = "Upgrade All (Except Armour)",
            description = "Upgrade Engine, Transmission, Suspension, Brakes and Turbo",
            icon = "arrow-up",
            event = events.PERFORMANCE_UPGRADES.ENABLE_ALL_EXCEPT_ARMOUR,
        },
        {
            title = "Downgrade All (Except Armour)",
            description = "Downgrade Engine, Transmission, Suspension, Brakes and Turbo",
            icon = "arrow-down",
            event = events.PERFORMANCE_UPGRADES.DISABLE_ALL_EXCEPT_ARMOUR,
        },
    }

    if enableCustom then
        SharedUtils.TableInsertMany(
            out,
            {
                title = "Upgrade with custom function",
                description = "Run the defined custom function to upgrade the current vehicle",
                icon = "upload",
                event = "vib_telemetry:events:client:config:custom:custom_upgrade_event",
                args = {
                    Vehicle = vehicle,
                },
            },
            {
                title = "Downgrade with custom function",
                description = "Run the defined custom function to downgrade the current vehicle",
                icon = "download",
                event = "vib_telemetry:events:client:config:custom:custom_downgrade_event",
                args = {
                    Vehicle = vehicle,
                },
            }
        )
    end

    return out
end