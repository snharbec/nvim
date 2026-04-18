return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        -- trigger = {
        --   prefetch_ms = 300,
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
        preset = "super-tab",
        ["<C-y>"] = { "select_and_accept" },
        ["<C-l>"] = { "select_and_accept" },
        ["<C-j>"] = { "select_next" },
        ["<C-k>"] = { "select_prev" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
      },
      -- Configure sources per filetype
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
          -- For markdown: only use LSP, nothing else
          markdown = { "lsp" },
        },
      },
    },
  },
}
