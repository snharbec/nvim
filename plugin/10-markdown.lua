-- Monkey-patch vim.treesitter.get_node_text to handle stale treesitter nodes
-- that report positions beyond the current buffer bounds. This happens when
-- treesitter hasn't re-parsed after buffer edits (common in render-markdown
-- during undo/redo or rapid typing).
local orig_get_node_text = vim.treesitter.get_node_text
vim.treesitter.get_node_text = function(node, source, opts)
  local ok, result = pcall(orig_get_node_text, node, source, opts)
  if ok then
    return result
  end
  if result and result:match("Index out of bounds") then
    return ""
  end
  error(result)
end

vim.pack.add({ 'https://github.com/MeanderingProgrammer/render-markdown.nvim' })
require("render-markdown").setup({
  bullet = {
    icons = { '◦', '∙', '○', '●' },
  },
})

vim.pack.add({ 'https://github.com/iamcco/markdown-preview.nvim' })

vim.pack.add({ 'https://github.com/bullets-vim/bullets.vim' })
