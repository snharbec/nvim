-- Keymaps are automatically loaded on the VeryLazy event

--------------------------------------------------------------------------
-- Helpers for a more concise `<Leader>` mappings.
--------------------------------------------------------------------------
local nmap = function(lhs, rhs, desc)
  vim.keymap.set({ "n", "x", "o" }, lhs, rhs, { desc = desc })
end
local imap = function(lhs, rhs, desc)
  vim.keymap.set("i", lhs, rhs, { desc = desc })
end
local xmap = function(lhs, rhs, desc)
  vim.keymap.set("x", lhs, rhs, { desc = desc })
end

imap("/p", "<C-o>:lua require('extra.daily').insert_link_to_note_type('project')<CR>")
imap("/e", "<C-o>:lua require('extra.daily').insert_link_to_note_type('person')<CR>")
imap("/d", "<C-o>:lua require('extra.daily').insert_link_to_note_type('daily')<CR>")
imap("/c", "<C-o>:lua require('extra.daily').insert_link_to_note_type('company')<CR>")
imap("/f", "<C-o>:lua require('extra.daily').insert_link_to_file()<CR>")
imap("/s", "<C-o>:lua require('extra.daily').insert_selection()<CR>")

nmap("<c-p>", "<Plug>(YankyPreviousEntry)")
nmap("<c-n>", "<Plug>(YankyNextEntry)")
nmap("<c-n>", "<Plug>(YankyNextEntry)")
nmap("<M-CR>", function()
  -- Get the current line number
  local line = vim.fn.line(".")
  -- Get the fold level of the current line
  local foldlevel = vim.fn.foldlevel(line)
  if foldlevel == 0 then
    vim.notify("No fold found", vim.log.levels.INFO)
  else
    vim.cmd("normal! za")
  end
end, "[P]Toggle fold")
imap("<c-BS>", "<C-w>")
imap("<c-h>", "<C-w>")
imap("<M-BS>", "<C-w>")

imap("<Up>", "<C-o>gk")
imap("<Down>", "<C-o>gj")

xmap("<Up>", "<C-o>gk")
xmap("<Down>", "<C-o>gj")
--------------------------------------------------------------------------
-- Leader keymap
--------------------------------------------------------------------------
local nmap_leader = function(suffix, rhs, desc)
  vim.keymap.set("n", "<Leader>" .. suffix, rhs, { desc = desc })
end

--------------------------------------------------------------------------
-- Git prefix
--------------------------------------------------------------------------
nmap_leader("gg", ":Neogit<CR>")

--------------------------------------------------------------------------
-- Search prefix
--------------------------------------------------------------------------
nmap_leader("ss", ":lua Snacks.picker.lines()<CR>")

local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

-- Repeat movement with ; and ,
-- ensure ; goes forward and , goes backward regardless of the last direction
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

-- vim way: ; goes to the direction you were moving.
-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
