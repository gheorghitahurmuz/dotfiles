return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")

      local builtin = require("telescope.builtin")
      vim.keymap.set(
        "n",
        "<leader>ff",
        builtin.find_files,
        { desc = "Fuzzy find files in cwd" }
      )
      vim.keymap.set(
        "n",
        "<leader>fg",
        builtin.live_grep,
        { desc = "Find string in cwd" }
      )
      vim.keymap.set(
        "n",
        "<leader>fb",
        builtin.buffers,
        { desc = "View buffers" }
      )

      telescope.setup()
    end,
  },
}
