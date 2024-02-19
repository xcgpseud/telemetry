Utils = {}

function Utils.NotifyPlayer(message, type, icon, position, duration)
    local cfg = Config.Notifications

    type = type or cfg.DefaultType
    icon = icon or cfg.DefaultIcon
    position = position or cfg.DefaultPosition
    duration = duration or cfg.DefaultDuration

    lib.notify({
        description = message,
        type = type,
        icon = icon,
        position = position,
        dutation = duration,
    })

    if SharedConfig.Debug then
        print(("Notified %s with the message: [%s]"):format(PlayerPedId(), message))
    end
end

function Utils.DisplayContext(contextOptions)
    if contextOptions.options == nil or #contextOptions.options == 0 then
        if SharedConfig.Debug then
            print("Could not get options for context menu")
        end
        return
    end

    lib.registerContext(contextOptions)
    Wait(Config.Wait)
    lib.showContext(contextOptions.id)
end

function Utils.GetPlayerData()
    return QBCore.Functions.GetPlayerData()
end

function Utils.CalculateHeadingToFaceCoords(coords)
    local pos = GetEntityCoords(PlayerPedId())
    local x = coords.x - pos.x
    local y = coords.y - pos.y

    return GetHeadingFromVector_2d(x, y)
end