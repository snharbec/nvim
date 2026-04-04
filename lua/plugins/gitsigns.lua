return {
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
      signcolumn = true,
      numhl = true,
      linehl = false,
      word_diff = false,
      update_debounce = 100,
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'underline'
      },
    },
  },
}
