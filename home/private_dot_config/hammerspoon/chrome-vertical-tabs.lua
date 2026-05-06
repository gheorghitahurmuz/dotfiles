-- Toggle Chrome's vertical tabs sidebar with Cmd+Ctrl+T
-- Only fires when Chrome is the focused app
-- Mirrors: https://github.com/saqibameen/chrome-sidebar-toggle

local function findSidebarToggle(element, depth)
    if depth > 10 then return nil end

    local role = element:attributeValue("AXRole")
    if role == "AXButton" then
        local desc = (element:attributeValue("AXDescription") or ""):lower()
        local title = (element:attributeValue("AXTitle") or ""):lower()
        if desc == "expand tabs" or desc == "collapse tabs"
            or title == "expand tabs" or title == "collapse tabs" then
            return element
        end
    end

    for _, child in ipairs(element:attributeValue("AXChildren") or {}) do
        local found = findSidebarToggle(child, depth + 1)
        if found then return found end
    end

    return nil
end

local function toggleChromeVerticalTabs()
    local app = hs.application.frontmostApplication()
    if not app or app:bundleID() ~= "com.google.Chrome" then return end

    local axApp = hs.axuielement.applicationElement(app)
    local windows = axApp:attributeValue("AXWindows")
    if not windows or #windows == 0 then return end

    local button = findSidebarToggle(windows[1], 0)
    if not button then
        hs.alert.show("Vertical tabs sidebar not found")
        return
    end

    button:performAction("AXPress")
end

local chromeHotkey
chromeHotkey = hs.hotkey.bind("ctrl", "z", function()
    local app = hs.application.frontmostApplication()
    if app and app:bundleID() == "com.google.Chrome" then
        toggleChromeVerticalTabs()
    else
        chromeHotkey:disable()
        hs.eventtap.keyStroke({ "ctrl" }, "z", 0)
        chromeHotkey:enable()
    end
end)
