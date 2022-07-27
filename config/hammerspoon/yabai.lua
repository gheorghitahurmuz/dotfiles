JSON = require("JSON")

function yabai(args, _callback)
  local callback
  if type(_callback) == "function" then
    callback = _callback
  else
    callback = function()
      return true
    end
  end

  hs.task.new("/usr/local/bin/yabai", nil, callback, args):start()
end

-- Navigation
hs.hotkey.bind({'alt'}, 'h', function()
  yabai({'-m', 'window', '--focus', "west"})
end)

hs.hotkey.bind({'alt'}, 'j', function()
  yabai({'-m', 'window', '--focus', "south"})
end)

hs.hotkey.bind({'alt'}, 'k', function()
  yabai({'-m', 'window', '--focus', "north"})
end)

hs.hotkey.bind({'alt'}, 'l', function()
  yabai({'-m', 'window', '--focus', "east"})
end)

-- For stack layout
hs.hotkey.bind({'alt'}, 'p', function()
  yabai({"-m", "window", "--focus", "stack.prev"})
end)

hs.hotkey.bind({'alt'}, 'n', function()
  yabai({"-m", "window", "--focus", "stack.next"})
end)

-- Toggle fullscreen
hs.hotkey.bind({"alt"}, "f", function()
  yabai({"-m", "window", "--toggle", "zoom-fullscreen"})
end)

-- Split a window vertically
hs.hotkey.bind({"alt"}, "-", function()
  yabai({"-m", "window", "--insert", "south"})
end)

-- Split a window horizontally
hs.hotkey.bind({"alt"}, "\\", function()
  yabai({"-m", "window", "--insert", "east"})
end)

-- Insert window in current stack
hs.hotkey.bind({"alt"}, "s", function()
  yabai({"-m", "window", "--insert", "stack"})
end)


-- Toggle float mode
hs.hotkey.bind({"ctrl", "alt"}, "space", function()
  yabai({"-m", "window", "--toggle", "float"})
end)


-- Move window
hs.hotkey.bind({"shift", 'alt'}, 'h', function()
  yabai({'-m', 'window', '--warp', "west"})
end)

hs.hotkey.bind({"shift", 'alt'}, 'j', function()
  yabai({'-m', 'window', '--warp', "south"})
end)

hs.hotkey.bind({"shift", 'alt'}, 'k', function()
  yabai({'-m', 'window', '--warp', "north"})
end)

hs.hotkey.bind({"shift", 'alt'}, 'l', function()
  yabai({'-m', 'window', '--warp', "east"})
end)

--Balance
hs.hotkey.bind({"ctrl", "alt"}, "=", function() 
  yabai({"-m", "space", "--balance"})
end)

-- Resize window
hs.hotkey.bind({"ctrl", 'alt'}, 'h', function()
  yabai({'-m', 'window', '--resize', "left:-100:0"})
  yabai({'-m', 'window', '--resize', "right:-100:0"})
end)

hs.hotkey.bind({"ctrl", 'alt'}, 'j', function()
  yabai({'-m', 'window', '--resize', "bottom:0:100"})
  yabai({'-m', 'window', '--resize', "top:0:100"})
end)

hs.hotkey.bind({"ctrl", 'alt'}, 'k', function()
  yabai({'-m', 'window', '--resize', "top:0:-100"})
  yabai({'-m', 'window', '--resize', "bottom:0:-100"})
end)

hs.hotkey.bind({"ctrl", 'alt'}, 'l', function()
  yabai({'-m', 'window', '--resize', "right:100:0"})
  yabai({'-m', 'window', '--resize', "left:100:0"})
end)
