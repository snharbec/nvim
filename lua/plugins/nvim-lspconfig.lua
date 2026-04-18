return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
    config = function()
      local lspconfig = require("lspconfig")
      
      -- Get capabilities from nvim-cmp if available, otherwise use default
      local capabilities
      local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if ok then
        capabilities = cmp_nvim_lsp.default_capabilities()
      else
        capabilities = vim.lsp.protocol.make_client_capabilities()
      end

      -- Lua Language Server
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library",
              },
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      -- Bash Language Server
      lspconfig.bashls.setup({
        capabilities = capabilities,
      })

      -- Markdown Oxide
      lspconfig.markdown_oxide.setup({
        capabilities = vim.tbl_deep_extend("force", capabilities, {
          workspace = {
            didChangedWatchedFiles = {
              dynamicRegistration = true,
            },
          },
        }),
      })
    end,
  },
}
