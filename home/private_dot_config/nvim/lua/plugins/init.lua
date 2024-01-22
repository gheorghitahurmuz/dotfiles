local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  require("plugins.colorscheme"),
  require("plugins.folder-tree"),
  require("plugins.icons"),
  require("plugins.statusline"),
  require("plugins.telescope"),
  require("plugins.treesitter"),
  require("plugins.lsp"),
  require("plugins.folding"),
  require("plugins.indentation"),
  require("plugins.comments"),
  require("plugins.autocomplete"),
  require("plugins.format"),
  require("plugins.lint"),
  require("plugins.utils"),
}, {})
