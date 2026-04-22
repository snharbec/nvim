# Neovim Config — AGENTS.md

## Architecture

- **Not LazyVim.** This is a vim.pack-based config with standalone lazy.nvim.
- `init.lua` — entrypoint; loads config modules, sets catppuccin colorscheme.
- `plugin/*.lua` — plugin definitions, **auto-sourced** by Neovim (not lazy.nvim spec). Loaded in numeric order. `plugin/` is a runtime pack directory.
- `vim.pack` — custom package manager with lockfile at `nvim-pack-lock.json`. Add plugins via `vim.pack.add()`, lock with `vim.pack.lock()` (update command on dashboard).
- `lua/config/` — `options.lua`, `keymaps.lua`, `autocmds.lua`, `lazy.lua`.
- `lua/plugins.old/` — deprecated plugins, kept as history.
- `ftplugin/` — filetype-specific overrides (markdown, java).
- `lua/snippets/` — LuaSnip snippets.

## Key Details

- **Leader:** `<space>`, **Localleader:** `,`
- **Colorscheme:** catppuccin (macchiato flavour, light background)
- **Lua formatter:** StyLua (2 spaces, 120 col) — configured in `stylua.toml`
- **LUA LSP:** `lazydev.nvim` configured in `lua/config/lazy.lua`; `.luarc.json` disables `deprecated` warning
- **Completion:** nvim-cmp + LuaSnip + friendly-snippets + cmp-nvim-lsp + cmp-buffer
- **Main picker:** snacks.nvim (replace with telescope — all keymaps use snacks)
- **UI:** nvim-tree.lua (sidebar), barbar (tab management), dashboard-nvim (startup), flash.nvim, gitsigns, neogit, noice, trouble, render-markdown, smear-cursor, treewalker, tabout, leap, guess-indent, mini.nvim suite, mini.surround, nvim-surround, bullets.vim, jira-oil
- **LSP servers:** lua_ls, bashls, marksman, markdown_oxide — installed via Mason, **not** mason-lspconfig (avoids deprecated lspconfig framework)
- **Java:** nvim-jdtls via ftplugin/java.lua — **hardcoded macOS path** (`/Users/har/.local/share/nvim/mason/packages/jdtls`), uses `config_mac` or `config_mac_arm`
- **Note search:** custom plugin loaded from GitHub (`snharbec/note_search`) via `vim.pack`; uses `NOTE_SEARCH_DIR` env var (default `~/.local/share/notes`); `lua/note-type` git submodule (private repo) is also referenced
- **Markdown filetype:** wrap at 100 chars, bullets.vim indent, tree-sitter header folding, note_search smart inserter
- **Session:** auto-restore per-directory (mini.sessions), auto-save on VimLeavePre
- **Git submodule:** `lua/note-type` → `git@github.com:har/note-type.git`

## Commands & Operations

- **Update plugins:** `:Lazy` or `lua vim.pack.update()` (dashboard shortcut: `u`)
- **Add a plugin:** add `vim.pack.add(...)` to the appropriate `plugin/NN-name.lua` file
- **Run StyLua:** `stylua .` (or `stylua --check .` to lint)
- **Lua lint:** `lua-language-server` (via Mason)
