QBCore = exports['qb-core']:GetCoreObject()

Config = {

    Debug = true,

    SpeedTest = {
        -- We'll record acceleration of 0-n and braking speeds of n-0
        -- where n is each speed in this table.
        SpeedsToRecord = {
            30,
            60,
            100,
        },
        -- This is where we teleport and where we face initially
        Location = {
            Label = "Runway",
            Coords = vector3(-1779.76, -2989.53, 15.0),
            Heading = 330.0,
        },
        -- This is where we wanna floor it towards
        Target = {
            Coords = vector3(-1409.37, -2342.89, 13.27),
        }
    },

    --[[
        These are the labels for different types of categories.
        In the shared vehicles system, vehicles are represented as so:
        ['banshee'] = {
            ['name'] = 'Banshee',
            ['brand'] = 'Bravado',
            ['model'] = 'banshee',
            ['price'] = 56000,
            ['category'] = 'sports',
            ['hash'] = `banshee`,
            ['shop'] = 'luxury',
        },

        The key in the below table must match the "category" in any vehicles you wish to test.
        If you have vehicles with the category set to "muscles" but others with the key "muscle" then
        they won't be grouped together. Ensure all of your vehicles match correctly and they'll show
        in the category search lists etc.
    ]]
    VehicleCategories = {
        boats = "Boats",
        compacts = "Compacts",
        coupes = "Coupes",
        cycles = "Cycles",
        emergency = "Emergency Vehicles",
        motorcycles = "Motorcycles",
        muscle = "Muscle Cars",
        offroad = "Off-road Vehicles",
        sedans = "Sedans",
        sportsclassics = "Classic Sports",
        sports = "Sports",
        supers = "Supercars",
        suvs = "SUVs",
        vans = "Vans",
    },

    -- If your menus don't seem to load correctly, or at all because the server is slow, increase
    -- this wait time slightly (around 50 at a time)
    ContextRegisterDisplayWait = 100,

    -- If you have issues spawning vehicles as part of the automatic tests, try increasing this by
    -- around 50 at a time. You will notice delays between each car increasing but it should eventually
    -- solve any issues caused by buggy vehicles
    WaitBetweenMajorActions = 300,

    -- Every notification presented in this resource uses these default values
    Notifications = {
        DefaultType = "inform",
        DefaultIcon = "car-side",
        DefaultPosition = "top",
        DefaultDuration = 5000,
    },

    -- This must be markdown - I'd avoid changing anything other than the wording in this one unless you know what to do with it
    -- Each |, - and : is important for the table layout
    Table = {
        Header =
            "| Speed Category (miles per hour) | Time taken in seconds |\n" ..
            "| :---: | :---: |",
        ResultTemplates = {
            Acceleration = "| 0 - %s | %s |",
            Braking = "| %s - 0 | %s |",
        },
    },
    Custom = {
        -- Disabling this will disable all options to use "custom upgrades" and only our default
        -- upgrade method will be available
        EnableCustomUpgradeAndDowngradeEvents = true,

        ---We already calculate the heading required to face the coords we're driving towards
        ---Leave this entire value as `nil` in order to use our default one, which relies on Ox
        ---and the vehiclekeys:client:SetOwner / QBCore.Functions.GetPlate functions existing
        ---(i.e. SpawnVehicleFunction = nil,)
        ---@param model string The vehicle model to spawn
        ---@param coords vector3 The coords we will spawn at
        ---@param heading number The heading we want to face
        -- SpawnVehicleFunction = nil,
        SpawnVehicleFunction = function(model, coords, heading)
            local ped = PlayerPedId()
            local hash = GetHashKey(model)
            lib.requestModel(hash, Config.WaitBetweenMajorActions * 5)

            local vehicle = CreateVehicle(hash, coords.x, coords.y, coords.z, heading, true, false)
            SetVehicleOnGroundProperly(vehicle)

            SetModelAsNoLongerNeeded(hash)

            -- Do this and wait til it's done; as per usual it's buggy
            TaskWarpPedIntoVehicle(ped, vehicle, -1)
            local tries = 0
            while not IsPedInVehicle(ped, vehicle, false) and tries <= 5 do
                Wait(Config.WaitBetweenMajorActions)
            end

            TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(vehicle))
        end,

        ---Leave this entire thing as nil to use our default one
        ---e.g. FixVehicleFunction = nil,
        ---@param vehicle table The vehicle entity
        -- FixVehicleFunction = nil,
        FixVehicleFunction = function(vehicle)
            print("Custom function used to fix!")
            TriggerEvent('iens:repaira')
            TriggerEvent('vehiclemod:client:fixEverything')
        end,
    }
}

-- Custom events for upgrade/downgrade options if our default ones don't work for you!

RegisterNetEvent("_telemetry:events:client:config:custom:custom_upgrade_event", function(args)
    -- The vehicle we are currently in, from the Shared Vehicles files
    local vehicle = args.Vehicle

    -- Just our current event to trigger upgrades on the current vehicle
    TriggerEvent("_telemetry:events:client:c:vp:pu:ENABLE_ALL_EXCEPT_ARMOUR")
end)

RegisterNetEvent("_telemetry:events:client:config:custom:custom_downgrade_event", function(args)
    -- The vehicle we are currently in, from the Shared Vehicles files
    local vehicle = args.Vehicle

    -- Just our current event to trigger downgrades on the current vehicle
    TriggerEvent("_telemetry:events:client:c:vp:pu:DISABLE_ALL_EXCEPT_ARMOUR")
end)

-- You can use the following event to run the existing performance upgrade code:
-- TriggerEvent("_telemetry:events:client:c:vp:pu:ENABLE_ALL_EXCEPT_ARMOUR")

-- And the following event to run the existing performance downgrade code:
-- TriggerEvent("_telemetry:events:client:c:vp:pu:DISABLE_ALL_EXCEPT_ARMOUR")
