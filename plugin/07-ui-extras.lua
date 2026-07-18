vim.pack.add({ 'https://github.com/folke/flash.nvim' })
vim.cmd.packadd('flash.nvim')
require("flash").setup()
vim.keymap.set("n", "s", function() require("flash").jump() end, { desc = "Flash jump" })

vim.pack.add({ 'https://github.com/echasnovski/mini.surround' })
vim.cmd.packadd('mini.surround')
require("mini.surround").setup()

vim.pack.add({ 'https://github.com/NMAC427/guess-indent.nvim' })
vim.cmd.packadd('guess-indent.nvim')
require("guess-indent").setup()
