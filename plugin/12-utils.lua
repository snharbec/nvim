-- Install and load plugins
vim.pack.add({
  "https://codeberg.org/andyg/leap.nvim.git",
  'https://github.com/sphamba/smear-cursor.nvim',
  'https://github.com/aaronik/treewalker.nvim',
  'https://github.com/abecodes/tabout.nvim',
  'https://github.com/sbulav/jira-oil.nvim',
  'https://github.com/stevearc/conform.nvim'
})

-- Ensure plugins are loaded with packadd
vim.cmd.packadd('leap.nvim')
vim.cmd.packadd('smear-cursor.nvim')
vim.cmd.packadd('treewalker.nvim')
vim.cmd.packadd('tabout.nvim')
vim.cmd.packadd('conform.nvim')

-- Leap
local ok_leap, leap = pcall(require, "leap")
if ok_leap then
  vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
  vim.keymap.set('n', 'S', '<Plug>(leap-from-window)') 
end

-- Smear cursor
local ok_smear, smear = pcall(require, "smear-cursor")
if ok_smear then
  smear.setup()
end

-- Treewalker
local ok_tree, treewalker = pcall(require, "treewalker")
if ok_tree then
  treewalker.setup()
end

-- Tabout
local ok_tabout, tabout = pcall(require, "tabout")
if ok_tabout then
  tabout.setup({
    tabkey = "<Tab>",
    backwards_tabkey = "<S-Tab>",
    act_as_tab = true,
    act_as_shift_tab = false,
    default_tab = "<C-t>",
    default_shift_tab = "<C-d>",
    completion = false,
    tabouts = {
      { open = "'", close = "'" },
      { open = '"', close = '"' },
      { open = '`', close = '`' },
      { open = '(', close = ')' },
      { open = '[', close = ']' },
      { open = '{', close = '}' },
      { open = '<', close = '>' },
    },
    ignore_beginning = true,
    exclude = {},
    stop_order = { "forward", "back" },
  })
end

-- Conform
local ok_conform, conform = pcall(require, "conform")
if ok_conform then
  conform.setup({
    formatters_by_ft = {
      markdown = { "prettier"},
    },
  })
end
