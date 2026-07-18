-- Noice should load early as it affects UI
vim.pack.add({ 'https://github.com/folke/noice.nvim' })
vim.cmd.packadd('noice.nvim')
vim.cmd.packadd('nui.nvim')

require("noice").setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = false,
    lsp_doc_border = false,
  },
})
