-- Autocommands

-- Restore cursor position when opening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Restore cursor position",
  group = vim.api.nvim_create_augroup("restore-cursor", { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Filetype specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function(args)
    -- Wrap lines in markdown
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.showbreak = "↪ "

    -- Treesitter-based folding for headers
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.opt_local.foldlevel = 99 -- Start with all folds open

    -- Fold/unfold with Tab on header lines
    vim.keymap.set("n", "<Tab>", function()
      local line = vim.api.nvim_get_current_line()
      if line:match("^#+") then
        return "za"
      end
      return "<Tab>"
    end, { remap = true, expr = true, buffer = args.buf, desc = "Toggle fold on header" })
  end,
})

-- LSP Attach keymaps
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    -- Use snacks picker for LSP navigation if available, fallback to native
    local has_snacks = pcall(require, "snacks")

    map("gd", has_snacks and function() Snacks.picker.lsp_definitions() end or vim.lsp.buf.definition, "[G]oto [D]efinition")
    map("gr", has_snacks and function() Snacks.picker.lsp_references() end or vim.lsp.buf.references, "[G]oto [R]eferences")
    map("gI", has_snacks and function() Snacks.picker.lsp_implementations() end or vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    map("gy", has_snacks and function() Snacks.picker.lsp_type_definitions() end or vim.lsp.buf.type_definition, "[G]oto T[y]pe Definition")
    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

    map("<leader>ds", vim.lsp.buf.document_symbol, "[D]ocument [S]ymbols")
    map("<leader>ws", vim.lsp.buf.workspace_symbol, "[W]orkspace [S]ymbols")
    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
    map("<leader>so", has_snacks and function() Snacks.picker.lsp_symbols() end or vim.lsp.buf.document_symbol, "LSP [S]ymbols")
    map("<leader>sO", has_snacks and function() Snacks.picker.lsp_workspace_symbols() end or vim.lsp.buf.workspace_symbol, "LSP [W]orkspace [S]ymbols")

    -- Document highlighting
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup("user-lsp-highlight", { clear = false })
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
        group = vim.api.nvim_create_augroup("user-lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "user-lsp-highlight", buffer = event2.buf })
        end,
      })
    end

    -- Inlay hints
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      map("<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
      end, "[T]oggle Inlay [H]ints")
    end
  end,
})
