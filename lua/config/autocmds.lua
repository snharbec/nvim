-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
-- vim.api.nvim_create_autocmd("VimLeavePre", {
--   pattern = "*",
--   callback = function()
--     if vim.g.savesession then
--       vim.api.nvim_command("mks!")
--     end
--   end,
-- })
--
local function codelens_supported(bufnr)
  for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if c.server_capabilities and c.server_capabilities.codeLensProvider then
      return true
    end
  end
  return false
end

vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave", "CursorHold", "BufEnter" }, {
  buffer = bufnr,
  callback = function()
    if codelens_supported(bufnr) then
      vim.lsp.codelens.refresh({ bufnr = bufnr })
    end
  end,
})

if codelens_supported(bufnr) then
  vim.lsp.codelens.refresh({ bufnr = bufnr })
end
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(args)
    -- vim.lsp.start({
    --   name = "iwes",
    --   cmd = { "iwes" },
    --   root_dir = vim.fs.root(args.buf, { ".iwe" }),
    --   flags = {
    --     debounce_text_changes = 500,
    --   },
    -- })
    -- vim.opt_local.foldmethod = "expr"
    -- vim.opt_local.foldtext = "v:lua.cim.treesitter.foldtext()" -- If using Treesitter
    -- vim.opt_local.foldexpr = "v:lua.cim.treesitter.foldexpr()" -- If using Treesitter
    -- -- If NOT using Treesitter, use: vim.opt_local.foldmethod = "marker"
    -- -- or a dedicated markdown plugin.
    vim.keymap.set("n", "<Tab>", function()
      -- Check if the current line starts with a Markdown header (#)
      local line = vim.api.nvim_get_current_line()
      if line:match("^#+") then
        return "za"
      end
      return "<Tab>"
    end, { remap = true, expr = true, buffer = true })
  end,
})
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
  callback = function(event)
    -- NOTE: Remember that Lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    -- -- Jump to the definition of the word under your cursor.
    -- --  This is where a variable was first declared, or where a function is defined, etc.
    -- --  To jump back, press <C-t>.
    map("gd", function()
      Snacks.picker.lsp_definitions()
    end, "[G]oto [D]efinition")
    --
    -- -- Find references for the word under your cursor.
    map("gr", function()
      Snacks.picker.lsp_references()
    end, "[G]oto [R]eferences")
    --
    -- -- Jump to the implementation of the word under your cursor.
    -- --  Useful when your language has ways of declaring types without an actual implementation.
    map("gI", function()
      Snacks.picker.lsp_implementations()
    end, "[G]oto [I]mplementation")

    -- Jump to the type of the word under your cursor.
    --  Useful when you're not sure what type a variable is and you want to see
    --  the definition of its *type*, not where it was *defined*.
    map("<leader>D", function()
      Snacks.picker.lsp_type_definitions()
    end, "Type [D]efinition")

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    map("<leader>ds", function()
      Snacks.picker.lsp_document_symbols()
    end, "[D]ocument [S]ymbols")

    -- Fuzzy find all the symbols in your current workspace.
    --  Similar to document symbols, except searches over your entire project.
    map("<leader>ws", function()
      Snacks.picker.lsp_dynamic_workspace_symbols()
    end, "[W]orkspace [S]ymbols")

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
        end,
      })
    end

    -- The following code creates a keymap to toggle inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      map("<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
      end, "[T]oggle Inlay [H]ints")
    end
  end,
})
