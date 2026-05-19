vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter' })
vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter-context' })

require("nvim-treesitter").setup({
  ensure_installed = { "all" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },

  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "<M-i>",
      scope_incremental = "<M-o>",
      node_decremental = "<M-I>",
    },
  },
})

require("treesitter-context").setup({
  enable = true,
  enable_autocmd = false,
  min_lines = 1,
  max_lines = 5,
  multiline_threshold = 20,
  trim_scope = "outer",
  separator = "_",
  trigger_on_jump = false,
  trigger_on_change = false,
})
