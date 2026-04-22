vim.pack.add({ 'https://github.com/nvim-tree/nvim-tree.lua' })
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = { width = 30 },
  renderer = { group_empty = true },
  filters = { dotfiles = true },
  on_attach = function(bufnr)
    local api = require("nvim-tree.api")
    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    api.config.mappings.default_on_attach(bufnr)
    vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
    vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
  end,
})
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle NvimTree", silent = true })

vim.pack.add({ 'https://github.com/romgrk/barbar.nvim' })
require("barbar").setup({
  commands = {
    next = {
      action = function(win) vim.api.nvim_win_call(win, function() require("barbar").navigation(1) end) end,
      shortcut = "n",
    },
    previous = {
      action = function(win) vim.api.nvim_win_call(win, function() require("barbar").navigation(-1) end) end,
      shortcut = "p",
    },
    last = {
      action = function(win) vim.api.nvim_win_call(win, function() require("barbar").navigation(-10000) end) end,
      shortcut = "a",
    },
    first = {
      action = function(win) vim.api.nvim_win_call(win, function() require("barbar").navigation(10000) end) end,
      shortcut = "g",
    },
  },
})

vim.pack.add({ 'https://github.com/nvimdev/dashboard-nvim' })

-- Custom stats function (replaces lazy.stats)
local function get_plugin_stats()
  local count = 0
  for _, _ in pairs(package.loaded) do
    count = count + 1
  end
  return { loaded = count, count = count }
end

require("dashboard").setup({
  theme = "hyper",
  config = {
    week_header = { enable = true },
    project = { enable = false },
    shortcut = {
      { desc = ' Todo', group = '@property', action = 'lua require("note_search.search").open_agenda_buffer()', key = 'a' },
      { desc = ' Daily', group = '@property', action = 'lua require("note_search.types").note("daily")', key = 'd' },
      { desc = ' File', group = '@property', action = 'lua Snacks.picker.files()', key = 'f' },
      { desc = ' Grep', group = '@property', action = 'lua Snacks.picker.grep()', key = 'g' },
      { desc = ' Rec', group = '@property', action = 'lua Snacks.picker.recent()', key = 'r' },
      { desc = ' Sess', group = '@property', action = 'SessionLoad', key = 's' },
      { desc = ' Conf', group = '@property', action = 'lua Snacks.picker.files({ cwd = vim.fn.stdpath("config") })', key = 'c' },
      { desc = ' Note', group = '@property', action = 'lua Snacks.picker.files({ cwd = os.getenv("NOTE_SEARCH_DIR") })', key = 'n' },
      { desc = ' Updat', group = '@property', action = 'lua vim.pack.update()', key = 'u' },
      { desc = ' Quit', group = '@property', action = 'qa', key = 'q' },
    },
    header = {
      "",
      "",
      "",
      "██╗  ██╗██╗    ███████╗████████╗███████╗███████╗ █████╗ ███╗   ██╗",
      "██║  ██║██║    ██╔════╝╚══██╔══╝██╔════╝██╔════╝██╔══██╗████╗  ██║",
      "███████║██║    ███████╗   ██║   █████╗  █████╗  ███████║██╔██╗ ██║",
      "██╔══██║██║    ╚════██║   ██║   ██╔══╝  ██╔══╝  ██╔══██║██║╚██╗██║",
      "██║  ██║██║    ███████║   ██║   ███████╗██║     ██║  ██║██║ ╚████║",
      "╚═╝  ╚═╝╚═╝    ╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝",
      "",
      "",
    },
    center = {
      { icon = "", icon_hl = "Title", desc = "Find File", desc_hl = "String", key = "f", key_hl = "Number", action = "lua Snacks.picker.files()" },
      { icon = "", desc = "Recent Files", desc_hl = "String", key = "r", key_hl = "Number", action = "lua Snacks.picker.recent()" },
      { icon = "", desc = "Find Text", desc_hl = "String", key = "g", key_hl = "Number", action = "lua Snacks.picker.grep()" },
      { icon = "", desc = "Config", desc_hl = "String", key = "c", key_hl = "Number", action = "lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })" },
      { icon = "", desc = "New File", desc_hl = "String", key = "e", key_hl = "Number", action = "enew" },
      { icon = "", desc = "Lazy", desc_hl = "String", key = "l", key_hl = "Number", action = "Lazy" },
      { icon = "", desc = "Mason", desc_hl = "String", key = "m", key_hl = "Number", action = "Mason" },
      { icon = "", desc = "Quit", desc_hl = "String", key = "q", key_hl = "Number", action = "qa" },
    },
    footer = function()
      local stats = get_plugin_stats()
      return { "", "⚡ Neovim loaded " .. stats.loaded .. " modules", "" }
    end,
  },
})

vim.keymap.set("n", "H", "<cmd>BufferPrevious<CR>", { desc = "Prev tab" })
vim.keymap.set("n", "L", "<cmd>BufferNext<CR>", { desc = "Next tab" })
