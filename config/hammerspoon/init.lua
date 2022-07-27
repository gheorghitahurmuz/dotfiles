require("yabai")

-- Reload config of Hammerspoon
hs.hotkey.bind({"alt", "shift"}, "r", function()
    hs.reload()
    hs.console.clearConsole()
end)

-- Open Alacritty
hs.hotkey.bind({"alt"}, "return", function()
    hs.execute("open -n '/Applications/Alacritty.app'")
end)


-- Disable hide window
hs.hotkey.bind({"cmd"}, "h", function() end)

