return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = { "all" },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        node_incremental = "v",
        node_decremental = "V",
      },
    },

    -- textobjects = {
    --   select = {
    --     enable = true,
    --     lookahead = true,
    --     keymaps = {
    --       ["af"] = "@function.outer",
    --       ["if"] = "@function.inner",
    --       ["ac"] = "@class.outer",
    --       ["ic"] = "@class.inner",
    --       ["aa"] = "@class.outer",
    --       ["ia"] = "@class.inner",
    --       ["a"] = "@parameter.outer",
    --       ["i"] = "@parameter.inner",
    --       ["I"] = "@variable.outer",
    --       ["iI"] = "@variable.inner",
    --       ["A"] = "@class.outer",
    --       ["iA"] = "@class.inner",
    --     },
    --   },
    --   move = {
    --     enable = true,
    --     set_jumps = true, -- whether to set jumps in the jumplist
    --     goto_next_start = {
    --       ["]m"] = "@function.outer",
    --       ["]]"] = "@class.outer",
    --     },
    --     goto_next_end = {
    --       ["]M"] = "@function.outer",
    --       ["]["] = "@class.outer",
    --     },
    --     goto_previous_start = {
    --       ["[m"] = "@function.outer",
    --       ["[["] = "@class.outer",
    --     },
    --     goto_previous_end = {
    --       ["[M"] = "@function.outer",
    --       ["[]"] = "@class.outer",
    --     },
    --   },
    -- },
  },
}
