return {
  {
    "saghen/blink.cmp",
    lazy = false, -- lazy loading handled internally
    dependencies = "rafamadriz/friendly-snippets",
    opts = {
      completion = {
        -- documentation = {
        --   auto_show = true,
        --   auto_show_delay = 500,
        -- },
        ghost_text = { enabled = true },
        documentation = { auto_show = true, auto_show_delay_ms = 1000 },
        menu = {
          auto_show = function(ctx)
            return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
          end,
        },
        list = {
          selection = {
            auto_insert = true,
            preselect = true,
          },
        },
      },
      keymap = {
        preset = "default",
        ["<C-y>"] = { "select_and_accept" },
        ["<C-l>"] = { "select_and_accept" },
        ["<C-j>"] = { "select_next" },
        ["<C-k>"] = { "select_prev" },
        ["<Down>"] = { "select_next" },
        ["<Up>"] = { "select_prev" },
        ["<CR>"] = { "accept", "fallback" },
        ["<C-space>"] = {
          function(cmp)
            cmp.show({ providers = { "snippets" } })
          end,
        },
        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_next()
            end
          end,
          "snippet_forward",
          "fallback",
        },
        ["<S-Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_prev()
            end
          end,
          "snippet_backward",
          "fallback",
        },
      },
    },
  },
}
