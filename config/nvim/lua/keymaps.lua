local wk = require("which-key")

vim.g.mapleader = " "


wk.register({
  ["<leader>"] = {
    e = { "<cmd>NeoTreeShowToggle<cr>", "Toggle NeoTree" },
    w = { "<cmd>Bdelete<cr>", "Close current buffer" },
    q = { "<cmd>qa<cr>", "Quit" },
    n = { "<cmd>enew<cr>", "New empty buffer" },
    l = { "<cmd>BufferLineCycleNext<cr>", "Go to next buffer" },
    h = { "<cmd>BufferLineCyclePrev<cr>", "Go to previous buffer" },
    L = { "<cmd>BufferLineMoveNext<cr>", "Move buffer next" },
    H = { "<cmd>BufferLineMovePrev<cr>", "Move buffer prev" },
    p = { "<cmd>BufferLinePick<cr>", "Pick a buffer" },
  },
})


