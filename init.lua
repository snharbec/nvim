-- Enable fast loader for better startup performance
vim.loader.enable()

-- Load configuration modules
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Note: Plugins in plugin/ directory are auto-sourced by Neovim
-- No need for manual plugin loading - vim.pack handles it
vim.cmd.colorscheme("catppuccin")
