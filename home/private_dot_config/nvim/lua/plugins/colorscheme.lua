local current = "night-owl"

local colorschemes = {
	["monokai-pro"] = {
		{
			"loctvl842/monokai-pro.nvim",
			config = function()
				require("monokai-pro").setup({
					transparent_background = true,
					filter = "spectrum",
					background_clear = {
						"telescope",
						"nvim-tree",
					},
				})

				vim.cmd.colorscheme("monokai-pro")
			end,
		},
	},
	["night-owl"] = {
		{
			"oxfist/night-owl.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				vim.cmd.colorscheme("night-owl")
			end,
		},
	},
}

return colorschemes[current]
