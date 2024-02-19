lib.addCommand("telemetry", {
    help = "Open Telemetry Menu",
}, function(source)
    TriggerClientEvent("VIB_TELEMETRY:OPEN", source)
end)
