vim.pack.add({ 'https://github.com/NeogitOrg/neogit' })
require("neogit").setup()
vim.keymap.set("n", "<leader>gg", ":Neogit<CR>", { desc = "Open Neogit" })

vim.pack.add({ 'https://github.com/lewis6991/gitsigns.nvim' })
require("gitsigns").setup()
