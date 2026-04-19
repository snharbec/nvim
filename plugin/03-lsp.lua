vim.pack.add({ 'https://github.com/williamboman/mason.nvim' })
vim.pack.add({ 'https://github.com/neovim/nvim-lspconfig' })
vim.pack.add({ 'https://github.com/folke/lazydev.nvim' })

vim.cmd.packadd('mason.nvim')
vim.cmd.packadd('nvim-lspconfig')
vim.cmd.packadd('lazydev.nvim')

require("mason").setup({
  ui = {
    check_outdated_packages_on_open = true,
    border = "none",
    width = 0.8,
    height = 0.8,
    icons = {
      package_installed = "◍",
      package_pending = "◍",
      package_uninstalled = "◍",
    },
  },
})

require("lazydev").setup({
  library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
})

local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = ok and cmp_nvim_lsp.default_capabilities() or vim.lsp.protocol.make_client_capabilities()

-- Configure LSP servers using the new native API (Neovim 0.11+)
-- This avoids the deprecated lspconfig.setup() framework
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" },
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config("bashls", { capabilities = capabilities })

vim.lsp.config("markdown_oxide", {
  capabilities = vim.tbl_deep_extend("force", capabilities, {
    workspace = { didChangedWatchedFiles = { dynamicRegistration = true } },
  }),
})

vim.lsp.config("marksman", {
  capabilities = capabilities,
  filetypes = { "markdown", "markdown.mdx" },
  root_markers = { ".git", ".marksman.toml", "README.md", "readme.md" },
})

-- Enable servers
vim.lsp.enable({ "lua_ls", "bashls", "markdown_oxide", "marksman" })

-- Install servers via Mason if not present
-- Note: mason-lspconfig is not used to avoid the deprecated lspconfig framework warning
vim.api.nvim_create_autocmd("User", {
  pattern = "MasonToolsStartingInstall",
  callback = function()
    vim.notify("Installing LSP servers via Mason...", vim.log.levels.INFO)
  end,
})
