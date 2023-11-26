
-- Skip for now
if true then
	return {}
end

local terminalApplicationName = "Warp"

return {
	init = function()
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
	end,
}
