vim.pack.add({ 'https://github.com/L3MON4D3/LuaSnip' })
vim.pack.add({ 'https://github.com/rafamadriz/friendly-snippets' })
vim.pack.add({ 'https://github.com/hrsh7th/nvim-cmp' })
vim.pack.add({ 'https://github.com/hrsh7th/cmp-nvim-lsp' })
vim.pack.add({ 'https://github.com/hrsh7th/cmp-buffer' })
vim.pack.add({ 'https://github.com/saadparwaiz1/cmp_luasnip' })

local luasnip = require("luasnip")
luasnip.config.setup({ history = true, updateevents = "TextChanged,TextChangedI" })
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip").add_snippets("markdown", require("snippets.markdown"))

local cmp = require("cmp")
cmp.setup({
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 1000 },
  },
  mapping = {
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.confirm({ select = true }),
    ["<Down>"] = cmp.mapping.select_next_item(),
    ["<Up>"] = cmp.mapping.select_prev_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then luasnip.jump(-1) else fallback() end
    end, { "i", "s" }),
  },
  sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "luasnip" } }, { { name = "buffer" } }),
})

cmp.setup.filetype("markdown", {
  sources = cmp.config.sources({ { name = "luasnip" }, { name = "nvim_lsp" }, { name = "buffer" } }),
})
