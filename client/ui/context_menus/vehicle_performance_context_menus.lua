UI.ContextMenus.VehiclePerformance = {}

function UI.ContextMenus.OpenVehiclePerformanceMainContextMenu()
    local options = UI.ContextMenuOptions.VehiclePerformance.GetVehiclePerformanceContextMenuOptions()

    Utils.DisplayContext({
        id = MENUS.VEHICLE_PERFORMANCE.MAIN,
        title = "Vehicle Performance",
        options = options,
        menu = MENUS.MAIN,
    })
end

function UI.ContextMenus.OpenVehiclePerformanceUpgradeMainContextMenu()
    local options = UI.ContextMenuOptions.VehiclePerformance.GetVehiclePerformanceUpgradeContextMenuOptions()

    Utils.DisplayContext({
        id = MENUS.VEHICLE_PERFORMANCE.PERFORMANCE_UPGRADES,
        title = "Performance Upgrades",
        options = options,
        menu = MENUS.VEHICLE_PERFORMANCE.MAIN
    })
end