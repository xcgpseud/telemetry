RegisterNetEvent(EVENTS.CLIENT.DATABASE.CREATE_TABLES, function()
    lib.callback.await(CALLBACKS.SERVER.CREATE_TABLES)
end)