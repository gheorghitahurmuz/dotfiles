require("packer").startup(function(use)
  use "wbthomason/packer.nvim"
  use "nvim-lua/plenary.nvim"
  use "moll/vim-bbye"
  use "akinsho/bufferline.nvim"
  use {
  "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = {
      "MunifTanjim/nui.nvim",
    }
  }
  use "jose-elias-alvarez/null-ls.nvim"
  use "kyazdani42/nvim-web-devicons"
  use "https://gitlab.com/__tpb/monokai-pro.nvim"
  use "nvim-lualine/lualine.nvim"
  use "williamboman/nvim-lsp-installer"
  use "neovim/nvim-lspconfig"
  use "nvim-treesitter/nvim-treesitter"
  use "lukas-reineke/indent-blankline.nvim"
  use "terrortylor/nvim-comment"
  use "folke/which-key.nvim"
  use "lewis6991/gitsigns.nvim"
  use "folke/trouble.nvim"
end)
