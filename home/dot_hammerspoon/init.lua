local config = {}

hs.window.animationDuration = 0

config.modules = {
	"terminal",
	"window_management",
}

for _, module_name in ipairs(config.modules) do
	local ok, module_logic = pcall(require, "modules/" .. module_name)

	if ok and type(module_logic.init) == "function" then
		module_logic.init()
	elseif not ok then
		print("Error " .. v)
	end
end
