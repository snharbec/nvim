return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      require("lspconfig").lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })
      require("lspconfig").bashls.setup({})
      require("lspconfig").markdown_oxide.setup({
        capabilities = vim.tbl_deep_extend("force", capabilities, {
          workspace = {
            didChangedWatchedFiles = {
              dynamicRegistration = true,
            },
          },
        }),
        -- on_attach = function()
        --   -- setup Markdown Oxide daily note commands
        --   if client.name == "markdown_oxide" then
        --     vim.api.nvim_create_user_command("Daily", function(args)
        --       local input = args.args
        --
        --       vim.lsp.buf.execute_command({ command = "jump", arguments = { input } })
        --     end, { desc = "Open daily note", nargs = "*" })
        --   end
        -- end,
      })
    end,
  },
}
