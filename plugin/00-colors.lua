vim.pack.add({ 'https://github.com/catppuccin/nvim' })
vim.cmd.packadd('nvim')

require("catppuccin").setup({
  flavour = "macchiato",
  transparent_background = false,
  show_end_of_buffer = false,
  term_colors = true,
})

vim.cmd.colorscheme("catppuccin")
