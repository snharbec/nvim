return {
  "neovim/nvim-lspconfig",
  lazy = false,
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  config = function()
    -- Wait for Mason to set up PATH
    local mason_registry = require("mason-registry")
    
    -- Get capabilities from nvim-cmp if available
    local capabilities
    local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if ok then
      capabilities = cmp_nvim_lsp.default_capabilities()
    else
      capabilities = vim.lsp.protocol.make_client_capabilities()
    end

    -- Configure Lua Language Server using vim.lsp.config
    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = {
              vim.env.VIMRUNTIME,
              "${3rd}/luv/library",
            },
            checkThirdParty = false,
          },
          telemetry = {
            enable = false,
          },
        },
      },
    })

    -- Configure Bash Language Server
    vim.lsp.config("bashls", {
      capabilities = capabilities,
    })

    -- Configure Markdown Oxide
    vim.lsp.config("markdown_oxide", {
      capabilities = vim.tbl_deep_extend("force", capabilities, {
        workspace = {
          didChangedWatchedFiles = {
            dynamicRegistration = true,
          },
        },
      }),
    })

    -- Configure Marksman for Markdown
    vim.lsp.config("marksman", {
      capabilities = capabilities,
      filetypes = { "markdown", "markdown.mdx" },
      root_markers = { ".git", ".marksman.toml", "README.md", "readme.md" },
    })

    -- Enable the language servers
    vim.lsp.enable({ "lua_ls", "bashls", "markdown_oxide", "marksman" })
  end,
}
