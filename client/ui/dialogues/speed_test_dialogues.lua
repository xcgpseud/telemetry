UI.Dialogues.SpeedTest = {}

local function _calculateTimeInSecondsBetweenTwoTimestamps(startTimestamp, endTimestamp)
    return endTimestamp == -1
        and -1
        or (endTimestamp - startTimestamp) / 1000
end

function UI.Dialogues.SpeedTest.GenerateHeaders()
    local ctx = Context.SpeedTest
    local speeds = {}

    for _, speed in ipairs(ctx.Accelerating.SpeedsRecorded) do
        table.insert(speeds, speed.SpeedInMph)
    end

    local headers = { "Vehicle Name", "Vehicle Label" }
    local accelHeaders, brakeHeaders = {}, {}

    for _, speedData in ipairs(ctx.Accelerating.SpeedsRecorded) do
        local speed = speedData.SpeedInMph

        table.insert(accelHeaders, ("0-%s"):format(speed))
        table.insert(brakeHeaders, ("%s-0"):format(speed))
    end

    return SharedUtils.MergeTables(headers, accelHeaders, SharedUtils.ReverseTable(brakeHeaders))
end

function UI.Dialogues.SpeedTest.GenerateValues(results)
    local out = {}

    for _, resultData in ipairs(results) do
        local vehicle = resultData.VehicleData.model
        local name = resultData.VehicleData.name

        local nameAppend = resultData.IsUpgraded
            and (
                resultData.CustomUpgrades
                and " (Upgraded - Custom)"
                or " (Upgraded)"
            ) or ""

        local row = { vehicle, name .. nameAppend }

        for _, speedData in ipairs(resultData.Accelerating.SpeedsRecorded) do
            if speedData.TimestampWhenReached == -1 then
                table.insert(row, "N/A")
            else
                table.insert(row, _calculateTimeInSecondsBetweenTwoTimestamps(
                    resultData.Accelerating.WhenStartedMoving,
                    speedData.TimestampWhenReached
                ))
            end
        end

        for i = #resultData.Braking.SpeedsRecorded, 1, -1 do
            local speedData = resultData.Braking.SpeedsRecorded[i]

            if speedData.TimestampWhenReached == -1 then
                table.insert(row, "N/A")
            else
                table.insert(row, _calculateTimeInSecondsBetweenTwoTimestamps(
                    speedData.TimestampWhenReached,
                    resultData.Braking.WhenStopped
                ))
            end
        end

        table.insert(out, row)
    end

    return out
end

function UI.Dialogues.SpeedTest.GenerateLargeResults(results)
    local headers = UI.Dialogues.SpeedTest.GenerateHeaders()
    local values = UI.Dialogues.SpeedTest.GenerateValues(results)

    local header = "| " .. table.concat(headers, " | ") .. " |\n"
    header = header .. "|" .. (" :---: |"):rep(#headers)

    local out = "" .. header .. "\n"

    for _, row in ipairs(values) do
        out = out .. "| " .. table.concat(row, " | ") .. " |\n"
    end

    return out
end

function UI.Dialogues.SpeedTest.GenerateResultsMarkdown()
    local out = "" .. Config.Table.Header .. "\n"
    local ctx = { accel = Context.SpeedTest.Accelerating, braking = Context.SpeedTest.Braking }

    for _, speedData in pairs(ctx.accel.SpeedsRecorded) do
        local speed = speedData.TimestampWhenReached ~= -1
            and _calculateTimeInSecondsBetweenTwoTimestamps(
                ctx.accel.WhenStartedMoving,
                speedData.TimestampWhenReached
            )
            or "N/A"

        out = out .. Config.Table.ResultTemplates.Acceleration:format(speedData.SpeedInMph, speed) .. "\n"
    end

    for _, speedData in pairs(ctx.braking.SpeedsRecorded) do
        local speed = speedData.TimestampWhenReached ~= -1
            and _calculateTimeInSecondsBetweenTwoTimestamps(
                speedData.TimestampWhenReached,
                ctx.braking.WhenStopped
            )
            or "N/A"

        out = out .. Config.Table.ResultTemplates.Braking:format(speedData.SpeedInMph, speed) .. "\n"
    end

    out = out ..
        ("\n > Max speed reached: %s in %s seconds"):format(
            ctx.accel.MaxSpeedReached,
            _calculateTimeInSecondsBetweenTwoTimestamps(
                ctx.accel.WhenStartedMoving,
                ctx.accel.WhenReachedMaxSpeed
            )
        )

    out = out ..
        ("\n\n > Braked from %s to 0 in %s seconds"):format(
            ctx.accel.MaxSpeedReached,
            _calculateTimeInSecondsBetweenTwoTimestamps(
                ctx.braking.WhenStartedBraking,
                ctx.braking.WhenStopped
            )
        )

    return out
end

function UI.Dialogues.SpeedTest.DisplayResults()
    local clicked = lib.alertDialog({
        header = "Speed Test Results",
        content = UI.Dialogues.SpeedTest.GenerateResultsMarkdown(),
        centered = true,
        cancel = true,
        size = "xl",
        -- labels = {
        --     confirm = "Copy to clipboard",
        -- },
    })

    if clicked ~= "confirm" then
        return
    end

    -- print("COPY TO CLIPBOARD")
end

function UI.Dialogues.SpeedTest.DisplayLargeResults(results)
    local clicked = lib.alertDialog({
        header = "Speed Test Results",
        content = UI.Dialogues.SpeedTest.GenerateLargeResults(results),
        centered = true,
        cancel = true,
        size = "xl",
        labels = {
            confirm = "Copy CSV to clipboard",
        },
    })

    if clicked ~= "confirm" then
        return
    end

    local headers = UI.Dialogues.SpeedTest.GenerateHeaders()
    local values = UI.Dialogues.SpeedTest.GenerateValues(results)

    lib.setClipboard(CsvHelper.TableToCsv(headers, values))
    Utils.NotifyPlayer("Copied CSV to clipboard")
end

function UI.Dialogues.SpeedTest.ConfirmBeginAutomatedGroupTest(group)
    local options = {
        {
            value = TestType.WithoutUpgrades,
            label = "Without upgrades",
        },
        {
            value = TestType.WithUpgrades,
            label = "With upgrades",
        },
        {
            value = TestType.Both,
            label = "Both (runs one test for each)",
        },
    }

    if Config.Custom.EnableCustomUpgradeAndDowngradeEvents then
        SharedUtils.TableInsertMany(
            options,
            {
                value = TestType.WithCustomUpgrades,
                label = "With upgrades (using custom defined function)",
            },
            {
                value = TestType.BothCustomUpgrades,
                label = "Both (runs one test for each, using custom defined function for upgrades)",
            }
        )
    end

    local input = lib.inputDialog(
        ("Run %s tests for the %s group. Are you sure?"):format(
            #group.VehicleNames,
            group.Name
        ),
        {
            {
                type = "select",
                label = "Select test type",
                icon = "flask-vial",
                description = "We have a few different test types available",
                options = options,
                required = true,
                default = TestType.WithoutUpgrades,
            },
        }
    )

    if input == nil or input[1] == nil then
        return false, nil
    end

    local testType = input[1]

    return true, testType
end

function UI.Dialogues.SpeedTest.ConfirmBeginCategoryTest(numberOfVehicles)
    local options = {
        {
            value = TestType.WithoutUpgrades,
            label = "Without upgrades",
        },
        {
            value = TestType.WithUpgrades,
            label = "With upgrades",
        },
        {
            value = TestType.Both,
            label = "Both (runs one test for each)",
        }
    }

    if Config.Custom.EnableCustomUpgradeAndDowngradeEvents then
        SharedUtils.TableInsertMany(
            options,
            {
                value = TestType.WithCustomUpgrades,
                label = "With upgrades (using custom defined function)",
            },
            {
                value = TestType.BothCustomUpgrades,
                label = "Both (runs one test for each, using custom defined function for upgrades)",
            }
        )
    end

    local input = lib.inputDialog(
        ("This will run speed tests for %s vehicles"):format(numberOfVehicles),
        {
            {
                type = "select",
                label = "Select test type",
                icon = "flask-vial",
                description = "We have a few different test types available",
                options = options,
                required = true,
                default = TestType.WithoutUpgrades,
            }
        }
    )

    if input == nil or input[1] == nil then
        return false, nil
    end

    local testType = input[1]

    return true, testType

    -- local clicked = lib.alertDialog({
    --     header = "Are you sure?",
    --     content = ("This will execute multiple speed tests for [%s] vehicles and will take a while")
    --         :format(numberOfVehicles) ..
    --         "\n\nYou can cancel a speed test by coming back to this menu and pressing the cancel button.",
    --     centered = true,
    --     cancel = true,
    --     size = "lg",
    -- })

    -- return clicked == "confirm"
end

function UI.Dialogues.SpeedTest.ConfirmBeginAutomaticSingleTest()
    local input = lib.inputDialog(
        "Are you sure?",
        {
            {
                type = "select",
                label = "Select test type",
                icon = "flask-vial",
                description = "We have a few different test types available",
                options = {
                    {
                        value = TestType.WithoutUpgrades,
                        label = "Without upgrades",
                    },
                    {
                        value = TestType.WithUpgrades,
                        label = "With upgrades",
                    },
                    {
                        value = TestType.Both,
                        label = "Both (runs one test for each)",
                    }
                },
                required = true,
                defailt = TestType.WithoutUpgrades,
            },
        }
    )

    if input == nil or input[1] == nil then
        return
    end

    local testType = input[1]

    local clicked = lib.alertDialog({
        header = "Are you sure?",
        content = "Are you sure you wish to begin an automatic speed test in your current vehicle?",
        centered = true,
        cancel = true,
        size = "lg",
    })

    if clicked ~= "confirm" then
        return false
    end

    Utils.NotifyPlayer("Beginning automatic speed test")
    SpeedTestService.BeginAutomaticSpeedTest(testType)
end

function UI.Dialogues.SpeedTest.ConfirmDeleteGroup(groupName)
    if Context.DoNotShow.DeleteGroup then
        return true
    end

    local input = lib.inputDialog(
        ("Are you sure you wish to delete the group named %s?"):format(groupName),
        {
            {
                type = "checkbox",
                label = "Do not show this again for this session",
                required = false,
            },
        }
    )

    if input == nil then
        return false
    end

    if input[1] then
        Context.DoNotShow.DeleteGroup = true
    end

    return true
end

function UI.Dialogues.SpeedTest.CreateGroupDialogue()
    local input = lib.inputDialog(
        "Create Group",
        {
            {
                type = "input",
                label = "Group Name",
                icon = "car-side",
                required = true,
            },
        }
    )

    if input == nil or input[1] == nil then
        if SharedConfig.Debug then
            print("Bad inputs")
        end
        return
    end

    local name = input[1]

    local group = lib.callback.await(
        CALLBACKS.SERVER.SPEED_TEST.GROUP.CREATE_GROUP,
        false,
        name,
        QBCore.Functions.GetPlayerData().citizenid
    )

    Utils.NotifyPlayer(("Created group with name [%s]"):format(group.Name))
end

function UI.Dialogues.SpeedTest.AddVehiclesFromCategoryToGroupDialogue(groupId, categoryName, vehicles)
    local group = lib.callback.await(
        CALLBACKS.SERVER.SPEED_TEST.GROUP.GET_GROUP_BY_ID,
        false,
        groupId
    )
    table.sort(vehicles, function(left, right)
        return string.upper(left.name) < string.upper(right.name)
    end)

    local options = {}
    for _, val in pairs(vehicles) do
        if not SharedUtils.ExistsInTable(group.VehicleNames, val.model) then
            table.insert(options, {
                value = val.model,
                label = val.name,
            })
        end
    end

    local input = lib.inputDialog(
        ("Select vehicles from the [%s] category"):format(categoryName),
        {
            {
                type = "multi-select",
                label = ("[%s]"):format(categoryName),
                options = options,
                required = true,
            },
        }
    )

    if input == nil or input[1] == nil then
        if SharedConfig.Debug then
            print("Bad inputs")
        end
        -- UI.ContextMenus.SpeedTesting.OpenGroupAddVehiclesMainContextMenu(groupId)
        return
    end

    local vehicleModels = input[1]

    local _, updateCount = lib.callback.await(
        CALLBACKS.SERVER.SPEED_TEST.GROUP.ADD_VEHICLES_TO_GROUP,
        false,
        groupId,
        vehicleModels
    )

    Utils.NotifyPlayer(
        updateCount > 0
        and ("Added %s vehicles to %s group unless duplicates exist"):format(updateCount, group.Name)
        or "No vehicles added."
    )

    UI.ContextMenus.SpeedTesting.OpenGroupAddVehiclesSelectCategoryContextMenu(groupId)
end

function UI.Dialogues.ShowAddVehiclesToGroupDialogue(groupId)
    local input = lib.inputDialog(
        "Type vehicle models in a comma-separated list",
        {
            {
                type = "input",
                label = "Comma-separated values",
                description = "Use vehicle spawn names, not display names",
                placeholder = "elegy,futo,sultan",
                icon = "font",
                required = true,
            },
        }
    )

    if input == nil or input[1] == nil then
        if SharedConfig.Debug then
            print("Bad inputs")
        end
        return
    end

    local vehicles = SharedUtils.SplitString(input[1], ',')

    local _, numberOfVehiclesAdded = lib.callback.await(
        CALLBACKS.SERVER.SPEED_TEST.GROUP.ADD_VEHICLES_TO_GROUP,
        false,
        groupId,
        vehicles
    )

    Utils.NotifyPlayer(("Updated group with %s new vehicles"):format(numberOfVehiclesAdded))

    UI.ContextMenus.Group.AddVehicleToGroupMainMenu(groupId)
end

function UI.Dialogues.SpeedTest.EditGroupVehicles(groupId)
    local group = lib.callback.await(
        CALLBACKS.SERVER.SPEED_TEST.GROUP.GET_GROUP_BY_ID,
        false,
        groupId
    )

    local vehicles = group.VehicleNames
    table.sort(vehicles, function(left, right)
        return string.upper(left) < string.upper(right)
    end)

    local selectOptions = {}
    for _, val in pairs(vehicles) do
        local vehicle = QBCore.Shared.Vehicles[val]

        if vehicle ~= nil then
            table.insert(selectOptions, {
                value = val,
                label = vehicle.name,
            })
        end
    end

    local options = {
        {
            type = "input",
            label = ("Rename group"),
            default = group.Name,
        },
        {
            type = "multi-select",
            label = "Update group vehicles",
            options = selectOptions,
            default = vehicles,
            clearable = true,
        }
    }

    local input = lib.inputDialog("Update Group", options)

    if input == nil or input[1] == nil or input[2] == nil then
        if SharedConfig.Debug then
            print("Bad inputs")
        end
        return
    end

    group.Name = input[1]
    group.VehicleNames = input[2]

    local updateSuccessful = lib.callback.await(
        CALLBACKS.SERVER.SPEED_TEST.GROUP.UPDATE_GROUP,
        false,
        group
    )

    Utils.NotifyPlayer(
        updateSuccessful
        and ("Updated [%s] group, which now has %s cars"):format(group.Name, #group.VehicleNames)
        or "No vehicles added."
    )

    UI.ContextMenus.Group.SelectCategoryForAddToGroup(groupId)
end
