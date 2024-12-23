return {
  {
    "saghen/blink.cmp",
    lazy = false, -- lazy loading handled internally
    dependencies = "rafamadriz/friendly-snippets",
    opts = {
      keymap = {
        preset = "super-tab",
        ["<C-y>"] = { "select_and_accept" },
        ["<C-l>"] = { "select_and_accept" },
      },
    },
  },
}
