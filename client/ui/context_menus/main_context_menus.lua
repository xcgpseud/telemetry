UI.ContextMenus.Main = {}

function UI.ContextMenus.Main.OpenMainContextMenu()
    local options = UI.ContextMenuOptions.Main.GetMainContextMenuOptions()

    Utils.DisplayContext({
        id = MENUS.MAIN,
        title = "Telemetry",
        options = options,
    })
end