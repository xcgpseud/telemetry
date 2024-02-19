QBCore = exports['qb-core']:GetCoreObject()

SharedConfig = {
    Vehicles = SharedUtils.GroupBy(QBCore.Shared.Vehicles, "category"),

    -- Note for the following:
    -- Only the ones listed are avalable currently.
    -- In the future I plan to add more upgrades which can potentially impact performance as optional
    -- additions to this upgrade system. It's pretty basic at the moment.

    -- You can comment these out to remove them from the upgrade functions
    PerformanceMods = {
        VehicleMods.mods.engine,
        VehicleMods.mods.transmission,
        VehicleMods.mods.suspension,
        VehicleMods.mods.brakes,
        VehicleMods.mods.turbo,
    },

    -- This is the list of mods used when you include armour and upgrade everything
    AllMods = {
        VehicleMods.mods.engine,
        VehicleMods.mods.transmission,
        VehicleMods.mods.suspension,
        VehicleMods.mods.brakes,
        VehicleMods.mods.turbo,
        VehicleMods.mods.armor,
    },
}
