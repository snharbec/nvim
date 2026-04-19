return {
  "nvim-treesitter/nvim-treesitter-context",
  opts = {
    enable = true,
    enable_autocmd = false,
    min_lines = 1,
    max_lines = 5,
    multiline_threshold = 20,
    trim_scope = "outer",
    separator = "_",
    trigger_on_jump = false,
    trigger_on_change = false,
    ignore_when_ale_enabled = false,
    custom_patterns = {},
    excludes = {},
  },
}
