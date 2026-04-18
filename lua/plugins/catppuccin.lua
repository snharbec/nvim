return {
  -- Catppuccin colorscheme
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false, -- make sure we load this during startup
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "macchiato",
      transparent_background = false,
      show_end_of_buffer = false,
      term_colors = true,
    })
  end,
}
