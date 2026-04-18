return {
  -- LuaSnip for snippets
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local luasnip = require("luasnip")
      luasnip.config.setup({
        history = true,
        updateevents = "TextChanged,TextChangedI",
      })
      -- Load friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()
      -- Load custom markdown snippets
      require("luasnip").add_snippets("markdown", require("snippets.markdown"))
    end,
  },
  -- nvim-cmp for completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = {
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 1000,
          },
        },
        mapping = {
          -- Documentation
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          -- Completion control
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          -- TAB inserts the selected entry
          ["<Tab>"] = cmp.mapping.confirm({ select = true }),
          -- Navigation in completion menu
          ["<Down>"] = cmp.mapping.select_next_item(),
          ["<Up>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          -- Snippet navigation with Shift-Tab
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
        }),
      })

      -- For markdown files: use LSP, snippets, and buffer
      cmp.setup.filetype("markdown", {
        sources = cmp.config.sources({
          { name = "luasnip" },
          { name = "nvim_lsp" },
          { name = "buffer" },
        }),
      })
    end,
  },
}
