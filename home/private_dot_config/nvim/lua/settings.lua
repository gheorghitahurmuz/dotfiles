local globals = {
  mapleader = " ",
  maplocalleader = " ",
}

local settings = {
  cursorline = true,
  number = true,
  relativenumber = true,
  foldcolumn = "1",
  foldlevel = 99,
  foldlevelstart = 99,
  foldenable = true,
  termguicolors = true,
  wrap = false,
  expandtab = true,
  tabstop = 2,
  softtabstop = 2,
  shiftwidth = 2,
}

vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]] 

for k, v in pairs(settings) do
  vim.opt[k] = v
end

for k, v in pairs(globals) do
  vim.g[k] = v
end

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function(data)
    -- buffer is a [No Name]
    local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

    -- buffer is a directory
    local directory = vim.fn.isdirectory(data.file) == 1

    if not no_name and not directory then
      return
    end

    -- change to the directory
    if directory then
      vim.cmd.cd(data.file)
    end

    -- open the tree
    require("nvim-tree.api").tree.open()
  end,
})

vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local tree_wins = {}
    local floating_wins = {}
    local wins = vim.api.nvim_list_wins()
    for _, w in ipairs(wins) do
      local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
      if bufname:match("NvimTree_") ~= nil then
        table.insert(tree_wins, w)
      end
      if vim.api.nvim_win_get_config(w).relative ~= "" then
        table.insert(floating_wins, w)
      end
    end
    if 1 == #wins - #floating_wins - #tree_wins then
      -- Should quit, so we close all invalid windows.
      for _, w in ipairs(tree_wins) do
        vim.api.nvim_win_close(w, true)
      end
    end
  end,
})
