return {
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      vim.opt.termguicolors = true

      require("nvim-tree").setup({
        view = {
          cursorline = true,
          side = "right",
          width = 30,
        },
        renderer = {
          indent_width = 2,
          indent_markers = {
            enable = false,
            inline_arrows = true,
            icons = {
              corner = "└",
              edge = "│",
              item = "│",
              bottom = "─",
              none = " ",
            },
          },
        },
        update_focused_file = {
          enable = true,
          update_root = true,
          ignore_list = {},
        },
      })

      vim.keymap.set(
        "n",
        "<leader>e",
        "<cmd>NvimTreeToggle<CR>",
        { desc = "Toggle File" }
      )
    end,
  },
}
