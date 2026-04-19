return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  config = function()
    require("dashboard").setup({
      theme = "hyper",
      config = {
        week_header = {
          enable = true,
        },
        project = {
          enable = false,
        },
        shortcut = {
          { desc = ' Todo', group = '@property', action = 'lua require("note_search.search").open_agenda_buffer()', key = 'a' },
          { desc = ' File', group = '@property', action = 'lua Snacks.picker.files()', key = 'f' },
          { desc = ' Grep', group = '@property', action = 'lua Snacks.picker.grep()', key = 'g' },
          { desc = ' Rec', group = '@property', action = 'lua Snacks.picker.recent()', key = 'r' },
          { desc = ' Sess', group = '@property', action = 'SessionLoad', key = 's' },
          { desc = ' Conf', group = '@property', action = 'lua Snacks.picker.files({ cwd = vim.fn.stdpath("config") })', key = 'c' },
          { desc = ' Note', group = '@property', action = 'lua Snacks.picker.files({ cwd = os.getenv("NOTE_SEARCH_DIR") })', key = 'n' },
          { desc = ' Updat', group = '@property', action = 'lua vim.pack.update()', key = 'u' },
          { desc = ' Quit', group = '@property', action = 'qa', key = 'q' },
        },
        header = {
          "",
          "",
          "",
          "██╗  ██╗██╗    ███████╗████████╗███████╗███████╗ █████╗ ███╗   ██╗",
          "██║  ██║██║    ██╔════╝╚══██╔══╝██╔════╝██╔════╝██╔══██╗████╗  ██║",
          "███████║██║    ███████╗   ██║   █████╗  █████╗  ███████║██╔██╗ ██║",
          "██╔══██║██║    ╚════██║   ██║   ██╔══╝  ██╔══╝  ██╔══██║██║╚██╗██║",
          "██║  ██║██║    ███████║   ██║   ███████╗██║     ██║  ██║██║ ╚████║",
          "╚═╝  ╚═╝╚═╝    ╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝",
          "",
          "",
        },
        center = {
          {
            icon = "",
            icon_hl = "Title",
            desc = "Find File",
            desc_hl = "String",
            key = "f",
            key_hl = "Number",
            action = "lua Snacks.picker.files()",
          },
          {
            icon = "",
            desc = "Recent Files",
            desc_hl = "String",
            key = "r",
            key_hl = "Number",
            action = "lua Snacks.picker.recent()",
          },
          {
            icon = "",
            desc = "Find Text",
            desc_hl = "String",
            key = "g",
            key_hl = "Number",
            action = "lua Snacks.picker.grep()",
          },
          {
            icon = "",
            desc = "Config",
            desc_hl = "String",
            key = "c",
            key_hl = "Number",
            action = "lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })",
          },
          {
            icon = "",
            desc = "New File",
            desc_hl = "String",
            key = "e",
            key_hl = "Number",
            action = "enew",
          },
          {
            icon = "",
            desc = "Lazy",
            desc_hl = "String",
            key = "l",
            key_hl = "Number",
            action = "Lazy",
          },
          {
            icon = "",
            desc = "Mason",
            desc_hl = "String",
            key = "m",
            key_hl = "Number",
            action = "Mason",
          },
          {
            icon = "",
            desc = "Quit",
            desc_hl = "String",
            key = "q",
            key_hl = "Number",
            action = "qa",
          },
        },
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return {
            "",
            "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. " ms",
            "",
          }
        end,
      },
    })
  end,
  dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
