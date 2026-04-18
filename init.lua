-- Load options first (before lazy.nvim)
require("config.options")

-- Bootstrap lazy.nvim and load plugins
require("config.lazy")

-- Load additional configuration
require("config.keymaps")
require("config.autocmds")

vim.cmd.colorscheme("catppuccin")
-- snacks-picker-layouts is loaded on-demand by plugins that need it
