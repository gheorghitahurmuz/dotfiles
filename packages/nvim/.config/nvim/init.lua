vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.undofile = true

-- Use the bundled explorer as a small tree sidebar.
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25
vim.keymap.set("n", "<leader>e", "<cmd>Lexplore<CR>", { desc = "Toggle file tree" })

if not vim.pack then
  vim.notify("This configuration requires Neovim 0.12+ for vim.pack.", vim.log.levels.ERROR)
  return
end

vim.pack.add({ "https://github.com/oxfist/night-owl.nvim" })
require("night-owl").setup()
vim.cmd.colorscheme("night-owl")
