vim.pack.add({ 'https://github.com/folke/flash.nvim' })
vim.cmd.packadd('flash.nvim')
require("flash").setup()
-- NOTE: flash intentionally defines no `s` mapping here. leap.nvim claims `s`/`S`
-- (see plugin/12-utils.lua), and flash's `require("flash").jump()` on `s` was
-- dead code. Flash remains available via f/F/t/T and the char plugins.

vim.pack.add({ 'https://github.com/echasnovski/mini.surround' })
vim.cmd.packadd('mini.surround')
require("mini.surround").setup()

vim.pack.add({ 'https://github.com/NMAC427/guess-indent.nvim' })
vim.cmd.packadd('guess-indent.nvim')
require("guess-indent").setup()
