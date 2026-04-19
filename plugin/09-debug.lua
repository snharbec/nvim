vim.pack.add({ 'https://github.com/folke/trouble.nvim' })
vim.cmd.packadd('trouble.nvim')
require("trouble").setup({})

-- rust-tools.nvim is deprecated and uses deprecated lspconfig framework
-- Using rustaceanvim instead (modern replacement)
vim.pack.add({ 'https://github.com/mrcjkb/rustaceanvim' })
vim.cmd.packadd('rustaceanvim')

-- Configure rustaceanvim (if needed)
-- rustaceanvim works out of the box with vim.lsp.config
