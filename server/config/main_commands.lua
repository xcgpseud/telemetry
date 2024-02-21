lib.addCommand("telemetry", {
    help = "Open Telemetry Menu",
}, function(source)
    TriggerClientEvent("TELEMETRY:OPEN", source)
end)
