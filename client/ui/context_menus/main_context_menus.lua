UI.ContextMenus.Main = {}

function UI.ContextMenus.Main.OpenMainContextMenu()
    local options = UI.ContextMenuOptions.Main.GetMainContextMenuOptions()

    Utils.DisplayContext({
        id = MENUS.MAIN,
        title = "Vibrant Telemetry",
        options = options,
    })
end