-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>gg", ":Neogit<CR>")
vim.keymap.set("n", "<leader>sf", ":FzfLua files<CR>")
vim.keymap.set("n", "<leader>fd", ":Neotree<CR>")
vim.keymap.set("n", "<leader>fo", ":Oil<CR>")
vim.keymap.set("n", "<leader>fs", ":Telescope resession<CR>")
vim.keymap.set("n", "<leader>ff", ":FzfLua files<CR>")
vim.keymap.set("n", "<leader><leader>", ":FzfLua lgrep_curbuf<CR>")
vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")
vim.keymap.set("n", "<CR>", function()
  -- Get the current line number
  local line = vim.fn.line(".")
  -- Get the fold level of the current line
  local foldlevel = vim.fn.foldlevel(line)
  if foldlevel == 0 then
    vim.notify("No fold found", vim.log.levels.INFO)
  else
    vim.cmd("normal! za")
  end
end, { desc = "[P]Toggle fold" })
