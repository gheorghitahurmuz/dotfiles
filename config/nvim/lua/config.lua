local set = vim.opt

set.termguicolors = true
set.hidden = true
set.number = true
set.relativenumber = true
set.numberwidth = 6

set.tabstop = 2
set.softtabstop = 2
set.shiftwidth = 2
set.expandtab = true

set.cursorline = true

-- ColorScheme 
vim.g.monokaipro_filter = "spectrum"
vim.g.monokaipro_italic_functions = true
vim.cmd("colorscheme monokaipro")

-- LuaLine
require("lualine").setup({
  options = {
    theme = "monokaipro",
  },
})

-- NVim - Tree
require("neo-tree").setup()

-- LSPConfig
require("nvim-lsp-installer").setup {
  automatic_installation = true
}

local lspconfig = require("lspconfig")
lspconfig.tsserver.setup({})


-- Indent Blankline
require("indent_blankline").setup {
  show_current_context = true,
  show_current_context_start = true,
}

-- NVim-comment
require("nvim_comment").setup()

-- Bufferline
require("bufferline").setup({
  options = {
    show_close_icon = false,
    show_buffer_close_icons = true,
    diagnostics = "nvim_lsp",
    offsets = {
      {
        filetype = "undotree",
        text = "Undotree",
        highlight = "PanelHeading",
      },
      {
        filetype = "NvimTree",
        text = "Explorer",
        highlight = "PanelHeading",
      },
      {
        filetype = "neo-tree",
        text = "Explorer",
        highlight = "PanelHeading",
      },
      {
        filetype = "DiffviewFiles",
        text = "Diff View",
        highlight = "PanelHeading",
      },
      {
        filetype = "flutterToolsOutline",
        text = "Flutter Outline",
        highlight = "PanelHeading",
      },
      {
        filetype = "Outline",
        text = "Symbols",
        highlight = "PanelHeading",
      },
      {
        filetype = "packer",
        text = "Packer",
        highlight = "PanelHeading",
      },
    },
  }
})

local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	ensure_installed = "all", -- one of "all" or a list of languages
	ignore_install = { "" }, -- List of parsers to ignore installing
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "css" }, -- list of language that will be disabled
	},
	autopairs = {
		enable = true,
	},
	indent = { enable = true, disable = { "python", "css" } },
})

-- null-ls
local nullLS = require("null-ls")
local handle = io.popen("npm root -g")
local nodeModuleDir = handle:read("*a")
local eslintExtraArgs = {"--resolve-plugins-relative-to", nodeModuleDir }
nullLS.setup({
  debug = true,
  sources = {
   nullLS.builtins.code_actions.eslint.with({
        extra_args = eslintExtraArgs
      }),
   nullLS.builtins.diagnostics.eslint.with({
        extra_args = eslintExtraArgs  
      }),
   nullLS.builtins.diagnostics.jsonlint,
   -- nullLS.builtins.code_actions.gitrebase,
   -- nullLS.builtins.code_actions.gitsigns,
   -- nullLS.builtins.diagnostics.gitlint,
   -- nullLS.builtins.diagnostics.editorconfig_checker,
   nullLS.builtins.diagnostics.luacheck,
   nullLS.builtins.formatting.prettierd,
  }
})
