vim.pack.add({ 'https://github.com/MeanderingProgrammer/render-markdown.nvim' })
require("render-markdown").setup({})

vim.pack.add({ 'https://github.com/iamcco/markdown-preview.nvim' })

vim.pack.add({ 'https://github.com/epwalsh/obsidian.nvim' })
require("obsidian").setup({
  workspaces = {
    {
      name = "notes",
      path = os.getenv("NOTE_SEARCH_DIR") or "~/notes",
    },
  },
})
