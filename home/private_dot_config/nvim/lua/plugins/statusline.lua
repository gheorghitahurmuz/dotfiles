return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = vim.g.colors_name,
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
        disabled_filetypes = { "NvimTree" },
      },
    },
  },
}
