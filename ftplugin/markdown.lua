-- Enable line wrapping
vim.opt_local.wrap = true
vim.opt_local.linebreak = true -- Don't break words in the middle
vim.opt_local.breakindent = true -- Maintain indentation on wrapped lines
vim.opt_local.showbreak = "↪ "

-- Remap j and k to move by visual lines, not logical lines
-- This lets you move "down" within a wrapped paragraph
vim.keymap.set("n", "j", "gj", { buffer = true, silent = true })
vim.keymap.set("n", "k", "gk", { buffer = true, silent = true })
require("note_search.expander").register_smart_inserter()
