return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")

      mason.setup()

      mason_lspconfig.setup({
        ensure_installed = {
          "cssls",
          "emmet_ls",
          "html",
          "jsonls",
          "lua_ls",
          "tsserver",
          "gopls"
        },

        automatic_installation = true,
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      { "antosha417/nvim-lsp-file-operations", config = true },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      local on_attach = function(clienr, bufnr)
        client.server_capabilities.semanticTokensProvider = nil

        vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", {
          noremap = true,
          silent = true,
          buffer = bufnr,
          desc = "Show references",
        })
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {
          noremap = true,
          silent = true,
          buffer = bufnr,
          desc = "Go to declaration",
        })
        vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", {
          noremap = true,
          silent = true,
          buffer = bufnr,
          desc = "Show definitions",
        })
        vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", {
          noremap = true,
          silent = true,
          buffer = bufnr,
          desc = "Show implementations",
        })
        vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", {
          noremap = true,
          silent = true,
          buffer = bufnr,
          desc = "Show type definitions",
        })
        vim.keymap.set(
          "n",
          "<leader>D",
          "<cmd>Telescope diagnostics bufnr=0<CR>",
          {
            noremap = true,
            silent = true,
            buffer = bufnr,
            desc = "Show line diagnostics",
          }
        )
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {
          noremap = true,
          silent = true,
          buffer = bufnr,
          desc = "Smart rename",
        })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, {
          noremap = true,
          silent = true,
          buffer = bufnr,
          desc = "Show documentation",
        })
        vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", {
          noremap = true,
          silent = true,
          buffer = bufnr,
          desc = "Restart LSP",
        })
      end

      local capabilities = cmp_nvim_lsp.default_capabilities()

      lspconfig["html"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      lspconfig["tsserver"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      lspconfig["cssls"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      lspconfig["emmet_ls"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "html", "css", "sass", "scss" },
      })

      lspconfig["gopls"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      lspconfig["lua_ls"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })
    end,
  },
}
