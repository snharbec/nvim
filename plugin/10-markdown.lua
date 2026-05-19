vim.pack.add({ 'https://github.com/MeanderingProgrammer/render-markdown.nvim' })
require("render-markdown").setup({
  bullet = {
    icons = { '◦', '∙', '○', '●' },
  },
})

vim.pack.add({ 'https://github.com/iamcco/markdown-preview.nvim' })

vim.pack.add({ 'https://github.com/bullets-vim/bullets.vim' })
