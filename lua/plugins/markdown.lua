return {
  {
    "yousefhadder/markdown-plus.nvim",
    ft = "markdown",
    opts = {
      enabled = true,
      features = {
        list_management = true,
        text_formatting = true,
        headers_toc = true,
        links = true,
        images = true,
        quotes = true,
        callouts = true,
        code_block = true,
        table = true,
        footnotes = true,
      },
      toc = {
        initial_depth = 2,
      },
      -- Callouts configuration
      callouts = {
        default_type = "NOTE", -- default: "NOTE"  default callout type when inserting
        custom_types = {}, -- default: {}  add custom types (e.g., { "DANGER", "SUCCESS" })
      },

      -- Table configuration
      table = {
        auto_format = true, -- default: true  auto format table after operations
        default_alignment = "left", -- default: "left"  alignment used for new columns
        confirm_destructive = true, -- default: true  confirm before transpose/sort operations
        keymaps = { -- Table-specific keymaps (prefix based)
          enabled = true, -- default: true  provide table keymaps
          prefix = "<leader>t", -- default: "<leader>t"  prefix for table ops
          insert_mode_navigation = true, -- default: true  Alt+hjkl cell navigation
        },
      },

      -- Footnotes configuration
      footnotes = {
        section_header = "Footnotes", -- default: "Footnotes"  header for footnotes section
        confirm_delete = true, -- default: true  confirm before deleting footnotes
      },

      -- List configuration
      list = {
        checkbox_completion = {
          enabled = false, -- default: false  add timestamps when checking tasks
          format = "emoji", -- default: "emoji"  timestamp format (see below)
          date_format = "%Y-%m-%d", -- default: "%Y-%m-%d"  os.date() format string
          remove_on_uncheck = true, -- default: true  remove timestamp when unchecking
          update_existing = true, -- default: true  update timestamp when re-checking
        },
      },

      -- Global keymap configuration
      keymaps = {
        enabled = true, -- default: true  set false to disable ALL default maps (use <Plug>)
      },

      -- Filetypes configuration
      filetypes = { "markdown" }, -- default: { "markdown" }
    },
  },
}
