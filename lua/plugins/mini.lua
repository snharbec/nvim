return {
  {
    "nvim-mini/mini.nvim",
    version = false,
    event = "VeryLazy",
    config = function()
      -- require("mini.jump2d").setup({
      --   dim = true,
      --   allowed_lines = {
      --     blank = false,
      --     cursor_before = true,
      --     cursor_at = true,
      --     cursor_after = true,
      --     fold = true,
      --   },
      -- })
      require("mini.sessions").setup({
        autowrite = true,
        directory = "~/.local/cache/nvim/sessions",
      })
      -- require("mini.files").setup({})
    end,
  },
}
