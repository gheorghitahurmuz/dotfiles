local terminalApplicationName = "Warp"

-- Launch of focus termainal app
hs.hotkey.bind({ "ctrl" }, "return", function()
	local terminalApplicationName = "Warp"
	local app = hs.application.get(terminalApplicationName)

	if app and app:isFrontmost() then
		app:hide()
	else
		local ok = hs.application.launchOrFocus(terminalApplicationName)
		if ok then
			-- Give it a moment to launch/focus before moving the window
			hs.timer.doAfter(0.1, function()
				local app = hs.application.get(terminalApplicationName)
				if app then
					local win = app:mainWindow()
					if win then
						win:moveToUnit("[100,50,0,0]")
					else
						hs.alert.show("No window found for " .. terminalApplicationName)
					end
				else
					hs.alert.show("Failed to find app " .. terminalApplicationName)
				end
			end)
		end
	end
end)

-- Window management
hs.hotkey.bind({ "ctrl", "alt" }, "left", function()
	-- size focused window to left half of display
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.x = max.x
	f.y = max.y
	f.w = max.w / 2
	f.h = max.h
	win:setFrame(f)
end)

hs.hotkey.bind({ "ctrl", "alt" }, "right", function()
	-- size focused window to right half of display
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.x = max.x + (max.w / 2)
	f.y = max.y
	f.w = max.w / 2
	f.h = max.h
	win:setFrame(f)
end)

hs.hotkey.bind({ "ctrl", "alt" }, "return", function()
	-- size focused window to size of desktop
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.x = max.x
	f.y = max.y
	f.w = max.w
	f.h = max.h
	win:setFrame(f)
end)

hs.hotkey.bind({ "ctrl", "alt" }, "up", function()
	-- size focused window to top half of display
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.x = max.x
	f.y = max.y
	f.w = max.w
	f.h = max.h / 2
	win:setFrame(f)
end)

hs.hotkey.bind({ "ctrl", "alt" }, "down", function()
	-- size focused window to bottom half of display
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.x = max.x
	f.y = max.y + (max.h / 2)
	f.w = max.w
	f.h = max.h / 2
	win:setFrame(f)
end)

function reloadConfig(files)
	for _, file in pairs(files) do
		if file:sub(-4) == ".lua" then
			hs.reload()
		end
	end
end

hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
