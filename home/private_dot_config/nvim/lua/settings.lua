local globals = {
  mapleader = " ",
  maplocalleader = " ",
}

local settings = {
  clipboard = "unnamed,unnamedplus",
  cursorline = true,
  number = true,
  relativenumber = true,
  foldcolumn = "0",
  foldnestmax = 0,
  foldlevel = 99,
  foldlevelstart = 99,
  termguicolors = true,
  wrap = false,
  expandtab = true,
  tabstop = 2,
  softtabstop = 2,
  shiftwidth = 2,
}

vim.opt.fillchars:append("eob: ")

for k, v in pairs(settings) do
  vim.opt[k] = v
end

for k, v in pairs(globals) do
  vim.g[k] = v
end
