local keymap = vim.keymap.set
local silent = { silent = true }

keymap({ "n", "v" }, "<Space>", "<Nop>", silent)
keymap("n", "<CR>", ":noh<CR><CR>", silent)
keymap("n", "x", "\"_x", silent)
keymap("n", "X", "\"_X", silent)
keymap("v", "x", "\"_x", silent)
keymap("v", "X", "\"_X", silent)
keymap("v", "p", "\"_dP", silent)
keymap("v", "<", "<gv", silent)
keymap("v", ">", ">gv", silent)
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap("n", "j", "v:count == 0 ? 'gj' :'j'", { expr = true, silent = true })
keymap("x", "K", ":move '<-2<CR>gv-gv", silent)
keymap("x", "J", ":move '>+1<CR>gv-gv", silent)
keymap("n", "<C-h>", "<C-w>h", silent)
keymap("n", "<C-j>", "<C-w>j", silent)
keymap("n", "<C-k>", "<C-w>k", silent)
keymap("n", "<C-l>", "<C-w>l", silent)
keymap("n", "gn", ":bn<CR>", silent)
keymap("n", "gp", ":bp<CR>", silent)
keymap("n", "<leader>s", "<cmd>w<CR>", silent)
keymap("n", "<leader>w", "<cmd>bd<CR>", silent)
keymap("n", "<leader>q", "<cmd>qa<CR>", silent)
