-- Window management
return {
	init = function()
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
	end,
}
