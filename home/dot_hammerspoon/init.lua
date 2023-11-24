hs.hotkey.bind({ "ctrl" }, "return", function()
  local terminalName = "Warp"
  local app = hs.application.get(terminalName)

  if app:isFrontmost() then
    app:hide()
  else
    hs.application.launchOrFocus(terminalName)
  end

  app:mainWindow():moveToUnit("[100,50,0,0]")
end)
