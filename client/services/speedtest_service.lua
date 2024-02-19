SpeedTestService = {}

function SpeedTestService._setTestHasStarted()
    Context.SpeedTest.Accelerating.WhenStartedMoving = GetGameTimer()
    Context.SpeedTest.IsAccelerating = true
    Utils.NotifyPlayer("Movement started - recording now.")
end

function SpeedTestService.CheckIfStartedMoving(currentSpeedInMph)
    if currentSpeedInMph > 0.1
        and not Context.SpeedTest.IsAccelerating
        and not Context.SpeedTest.IsBraking
    then
        SpeedTestService._setTestHasStarted()
    end
end

function SpeedTestService.RunAccelerationCheck(vehicle, currentSpeedInMph)
    local timestamp = GetGameTimer()
    -- local ctx = Context.SpeedTest.Accelerating

    if Context.SpeedTest.Accelerating.CurrentSpeedKey == -1 then
        Context.SpeedTest.Accelerating.CurrentSpeedKey = 1
    end

    if Context.SpeedTest.Accelerating.PassedFinalSpeedCheck or Context.SpeedTest.Accelerating.SpeedsRecorded[Context.SpeedTest.Accelerating.CurrentSpeedKey] == nil then
        Context.SpeedTest.Accelerating.PassedFinalSpeedCheck = true
        goto MaxSpeedUpdate
    end

    if currentSpeedInMph > Context.SpeedTest.Accelerating.SpeedsRecorded[Context.SpeedTest.Accelerating.CurrentSpeedKey].SpeedInMph then
        Context.SpeedTest.Accelerating.SpeedsRecorded[Context.SpeedTest.Accelerating.CurrentSpeedKey].TimestampWhenReached =
            timestamp
        Context.SpeedTest.Accelerating.CurrentSpeedKey = Context.SpeedTest.Accelerating.CurrentSpeedKey + 1
    end

    :: MaxSpeedUpdate ::

    if currentSpeedInMph > Context.SpeedTest.Accelerating.MaxSpeedReached then
        Context.SpeedTest.Accelerating.MaxSpeedReached = currentSpeedInMph
        Context.SpeedTest.Accelerating.WhenReachedMaxSpeed = timestamp
    end

    -- We do this here as we want to share the same exact timestamp of this check
    if GetVehicleWheelBrakePressure(vehicle, 1) > 0 then
        Utils.NotifyPlayer("Braking phase started")
        Context.SpeedTest.IsBraking = true
        Context.SpeedTest.IsAccelerating = false
        Context.SpeedTest.Braking.WhenStartedBraking = timestamp
    end
end

function SpeedTestService.RunBrakingCheck(currentSpeedInMph)
    local timestamp = GetGameTimer()
    -- local ctx = Context.SpeedTest.Braking

    -- If we've finished our individual speed checks
    if Context.SpeedTest.Braking.CurrentSpeedKey == 0 then
        goto Final
    end

    if Context.SpeedTest.Braking.CurrentSpeedKey == -1 then
        Context.SpeedTest.Braking.CurrentSpeedKey = Context.SpeedTest.Accelerating.CurrentSpeedKey - 1
    end

    if currentSpeedInMph < Context.SpeedTest.Braking.SpeedsRecorded[Context.SpeedTest.Braking.CurrentSpeedKey].SpeedInMph then
        Context.SpeedTest.Braking.SpeedsRecorded[Context.SpeedTest.Braking.CurrentSpeedKey].TimestampWhenReached =
            timestamp
        Context.SpeedTest.Braking.CurrentSpeedKey = Context.SpeedTest.Braking.CurrentSpeedKey - 1
    end

    :: Final ::

    if Context.SpeedTest.Braking.WhenStopped == -1 and currentSpeedInMph < 0.1 then
        Utils.NotifyPlayer("The vehicle has stopped")
        Context.SpeedTest.Braking.WhenStopped = timestamp
        Context.SpeedTest.IsFinished = true
        -- Context.SpeedTest.IsRunning = false
    end
end

function SpeedTestService.TeleportToRunway()
    local player = PlayerPedId()

    SetPedCoordsKeepVehicle(player, Config.SpeedTest.Location.Coords)
    SetEntityHeading(player, Config.SpeedTest.Location.Heading)
end

function SpeedTestService._IsAccelerating(vehicle)
    local start, dest = Config.SpeedTest.Location, Config.SpeedTest.Target
    local startXIsGreater = start.Coords.x > dest.Coords.x
    local startYIsGreater = start.Coords.y > dest.Coords.y

    local coords = GetEntityCoords(vehicle)

    local xMatch = false

    if (coords.x < dest.Coords.x and not startXIsGreater) or
        (coords.x > dest.Coords.x and startXIsGreater) then
        xMatch = true
    end

    if (coords.y < dest.Coords.y and not startYIsGreater) or
        (coords.y > dest.Coords.y and startYIsGreater) and
        xMatch
    then
        return true
    end
end

function SpeedTestService.BeginManualSpeedTest(displayResults)
    displayResults = displayResults or true

    local vehicle = GetVehiclePedIsIn(PlayerPedId())

    if vehicle == 0 then
        Utils.NotifyPlayer("You're not in a vehicle!")
        return
    end

    Context:ResetSpeedTestContext()
    Context.SpeedTest.IsRunning = true

    Utils.NotifyPlayer("Test initiated - accelerate when ready to begin")

    SpeedTestService.StartManualTestThread(vehicle, displayResults)
end

function SpeedTestService.BeginAutomatedSingleTest()
    local confirmed = UI.Dialogues.SpeedTest.ConfirmBeginAutomaticSingleTest()

    if not confirmed then
        return false
        --  return UI.ContextMenus.SpeedTesting.OpenSpeedTestMainContextMenu()
    end

    SpeedTestService.BeginAutomaticSpeedTest()
end

function SpeedTestService.BeginAutomatedGroupTest(groupId)
    local group = lib.callback.await(CALLBACKS.SERVER.SPEED_TEST.GROUP.GET_GROUP_BY_ID, false, groupId)
    local confirmed, testType = UI.Dialogues.SpeedTest.ConfirmBeginAutomatedGroupTest(group)

    if not confirmed then
        -- lib.showContext(MENUS.SPEED_TESTING.GROUP_AUTOMATIC_TESTING.MAIN)
        return false
    end

    local vehicles = {}
    for _, vehicleName in ipairs(group.VehicleNames) do
        local vehicle = QBCore.Shared.Vehicles[vehicleName]
        if vehicle ~= nil then
            table.insert(vehicles, vehicle)
        end
    end

    SpeedTestService.RunMultipleTests(vehicles, testType, groupId)
end

function SpeedTestService.BeginCategoryTest(categoryName)
    local vehicles = {}

    for _, vehicleData in pairs(QBCore.Shared.Vehicles) do
        if vehicleData.category == categoryName then
            table.insert(vehicles, vehicleData)
        end
    end

    local confirmed, testType = UI.Dialogues.SpeedTest.ConfirmBeginCategoryTest(#vehicles)

    if not confirmed then
        return false
    end

    local vehiclesToTest = {}
    for _, vehicle in ipairs(vehicles) do
        if QBCore.Shared.Vehicles[vehicle.name] ~= nil then
            table.insert(vehiclesToTest, vehicle)
        end
    end

    SpeedTestService.RunMultipleTests(vehicles, testType, -1, categoryName)
end

function SpeedTestService.StartManualTestThread(vehicle, displayResults)
    if displayResults == nil then
        displayResults = true
    end

    Citizen.CreateThread(function()
        while true do
            local speedInMph = GetEntitySpeed(vehicle) * 2.236936

            SpeedTestService.CheckIfStartedMoving(speedInMph)

            if Context.SpeedTest.IsAccelerating and not Context.SpeedTest.IsBraking then
                SpeedTestService.RunAccelerationCheck(vehicle, speedInMph)
            end

            if Context.SpeedTest.IsBraking then
                SpeedTestService.RunBrakingCheck(speedInMph)
            end

            if Context.SpeedTest.IsFinished then
                if displayResults then
                    UI.Dialogues.SpeedTest.DisplayResults()
                end

                return
            end

            Citizen.Wait(1)
        end
    end)
end

function SpeedTestService.SpawnVehicle(vehicleName, coords, heading)
    local ped = PlayerPedId()
    local hash = GetHashKey(vehicleName)
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
end

-- Vehicle format is same as the shared.lua
function SpeedTestService.RunMultipleTests(vehicles, type, groupId, categoryName)
    groupId = groupId or -1
    categoryName = categoryName or ""

    if vehicles == nil or type == nil then
        if SharedConfig.Debug then
            print("One of the params was null in SpeedTestService.RunMultipleTests")
        end
    end

    local results = {}
    local runDetails = {}

    for _, vehicleData in ipairs(vehicles) do
        if (
                type == TestType.WithoutUpgrades
                or type == TestType.WithUpgrades
                or type == TestType.WithCustomUpgrades
            ) then
            table.insert(runDetails, {
                vehicleData = vehicleData,
                type = type,
            })
        else
            SharedUtils.TableInsertMany(
                runDetails,
                {
                    vehicleData = vehicleData,
                    type = TestType.WithoutUpgrades,
                },
                {
                    vehicleData = vehicleData,
                    type = type == TestType.BothCustomUpgrades
                        and TestType.WithCustomUpgrades
                        or TestType.WithUpgrades,
                }
            )
        end
    end

    if SharedConfig.Debug then
        print("our run details looks like this", json.encode(runDetails, { pretty = true }))
    end

    local player = PlayerPedId()
    Context.SpeedTest.IsRunning = true

    TriggerEvent("QBCore:Command:DeleteVehicle", player)

    for _, data in ipairs(runDetails) do
        if not Context.SpeedTest.IsRunning then
            SpeedTestService.EndTests(groupId, categoryName, results, true)
            return
        end

        local vehicleData = data.vehicleData
        SpeedTestService.TeleportToRunway()

        local coords = Config.SpeedTest.Target.Coords
        local heading = Utils.CalculateHeadingToFaceCoords(coords)

        if Config.Custom.SpawnVehicleFunction == nil then
            SpeedTestService.SpawnVehicle(
                vehicleData.model,
                Config.SpeedTest.Location.Coords,
                heading
            )
        else
            Config.Custom.SpawnVehicleFunction(
                vehicleData.model,
                Config.SpeedTest.Location.Coords,
                heading
            )
        end

        Context:ResetSpeedTestContext()
        Context:GetSpeedTestContext().IsRunning = true

        -- Move the vehicle to the test start
        Wait(Config.WaitBetweenMajorActions)

        -- We'll wait around until this works, it's buggy for some reason
        local vehicle = GetVehiclePedIsIn(player)

        local tries = 0
        while vehicle == 0 and tries < 5 do
            Wait(Config.WaitBetweenMajorActions)
        end

        if vehicle == 0 then
            Utils.NotifyPlayer("Something went wrong with spawning a vehicle")
            Context:GetSpeedTestContext().IsRunning = false
            break
        end

        SetRadioToStationIndex(0)
        SetRadioToStationName("OFF")

        if data.type == TestType.WithUpgrades then
            Utils.NotifyPlayer("Upgrading this vehicle, please wait...")
            PerformanceService.SetAllPerformanceMods(vehicle, true)
        end

        if data.type == TestType.WithCustomUpgrades then
            Utils.NotifyPlayer("Upgrading this vehicle with CUSTOM function, please wait...")
            TriggerEvent("vib_telemetry:events:client:config:custom:custom_upgrade_event", {
                Vehicle = vehicle,
            })
        end

        Wait(Config.WaitBetweenMajorActions)
        SpeedTestService.StartManualTestThread(vehicle, false)
        Wait(Config.WaitBetweenMajorActions)

        TaskVehicleDriveToCoord(
            player, vehicle, coords.x, coords.y, coords.z,
            500.0, 1.0, GetHashKey(GetEntityModel(vehicle)),
            16777216, 1.0, 1.0
        )

        Wait(1000)

        while SpeedTestService._IsAccelerating(vehicle) do
            Wait(6)
        end

        while GetEntitySpeed(vehicle) > 0.1 do
            TaskVehicleTempAction(player, vehicle, 24, 6)
            SetVehicleBrake(vehicle, true)
            Wait(6)
        end

        Wait(Config.WaitBetweenMajorActions)

        table.insert(results, {
            VehicleData = vehicleData,
            IsUpgraded = data.type == TestType.WithUpgrades or data.type == TestType.WithCustomUpgrades,
            CustomUpgrades = data.type == TestType.WithCustomUpgrades,
            Accelerating = SharedUtils.DeepCopy(Context:GetSpeedTestContext().Accelerating),
            Braking = SharedUtils.DeepCopy(Context:GetSpeedTestContext().Braking),
        })

        Wait(100)
        TriggerEvent('QBCore:Command:DeleteVehicle', player)
    end

    SpeedTestService.EndTests(groupId, categoryName, results, false)
end

function SpeedTestService.EndTests(
    groupId,
    categoryName,
    results,
    wasCancelled
)
    local shouldSaveRun = {
        (
            SharedConfig.SaveCategoryRuns
            and categoryName ~= nil
            and categoryName ~= ""
        ) or (
            SharedConfig.SaveGroupRuns
            and groupId ~= nil
            and groupId ~= -1
        )
    }

    if shouldSaveRun then
        local playerData = Utils.GetPlayerData()
        local result = lib.callback.await(
            CALLBACKS.SERVER.SPEED_TEST.SAVE_RUN,
            false,
            playerData.citizenid,
            groupId,
            categoryName,
            results,
            wasCancelled
        )

        if SharedConfig.Debug then
            print("Save result", json.encode(result, { pretty = true }))
        end
    end

    UI.Dialogues.SpeedTest.DisplayLargeResults(results)
end

function SpeedTestService.CancelOngoingTests()
    Context:GetSpeedTestContext().IsRunning = false
end

function SpeedTestService.DeleteGroup(groupId)
    local group = lib.callback.await(CALLBACKS.SERVER.SPEED_TEST.GROUP.GET_GROUP_BY_ID, false, groupId)
    local confirmed = UI.Dialogues.SpeedTest.ConfirmDeleteGroup(group.Name)

    if not confirmed then
        return
    end

    local isGroupDeleted = lib.callback.await(
        CALLBACKS.SERVER.SPEED_TEST.GROUP.DELETE_GROUP,
        false,
        groupId
    )

    if not isGroupDeleted then
        Utils.NotifyPlayer(
            ("There was an issue when attempting to delete your group (%s)"):format(group.Name)
        )
        return
    end

    Utils.NotifyPlayer(("Group [%s] deleted"):format(group.Name))
end
