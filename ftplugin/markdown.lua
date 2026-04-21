-- Enable line wrapping
vim.opt_local.wrap = true
vim.opt_local.linebreak = true -- Don't break words in the middle
vim.opt_local.breakindent = true -- Maintain indentation on wrapped lines
vim.opt_local.showbreak = "↪ "

-- Auto-wrap at 80 characters
vim.opt_local.textwidth = 100
vim.opt_local.formatoptions:append("t") -- Auto-wrap text using textwidth
vim.opt_local.formatoptions:remove("l") -- Allow wrapping long lines in insert mode

-- Remap j and k to move by visual lines, not logical lines
-- This lets you move "down" within a wrapped paragraph
vim.keymap.set("n", "j", "gj", { buffer = true, silent = true })
vim.keymap.set("n", "k", "gk", { buffer = true, silent = true })
require("note_search.expander").register_smart_inserter()

-- Bullets.vim keybindings for list indentation
vim.keymap.set("i", "<Tab>", "<C-o>:BulletDemote<CR>", { buffer = true, silent = true, desc = "Demote bullet" })
vim.keymap.set("i", "<S-Tab>", "<C-o>:BulletPromote<CR>", { buffer = true, silent = true, desc = "Promote bullet" })
