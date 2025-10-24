return {
  {
    "nmac427/guess-indent.nvim",
    config = true,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "lazy",
          "mason",
        },
      },
    },
  },
}
