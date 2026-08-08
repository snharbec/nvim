vim.pack.add({ 'https://github.com/folke/snacks.nvim' })
vim.cmd.packadd('snacks.nvim')

require("snacks").setup({
  bigfile = { enabled = true },
  notifier = { enabled = true },
  quickfile = { enabled = true },
  layout = {
    cycle = true,
    preset = "ivy",
  },
  picker = {
    enabled = true,
    ui_select = true,
    win = {
      input = {
        keys = {
          ["<A-c>"] = { "cycle_layouts", mode = { "i", "n" } },
          ["<A-d>"] = { "toggle_cwd", mode = { "i", "n" } },
          ["<C-c>"] = { "close", mode = { "i", "n" } },
          ["<C-n>"] = { "list_down", mode = { "i", "n" } },
          ["<C-p>"] = { "list_up", mode = { "i", "n" } },
          ["<C-j>"] = { "list_down", mode = { "i", "n" } },
          ["<C-k>"] = { "list_up", mode = { "i", "n" } },
          ["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
          ["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
          ["<CR>"] = { "confirm", mode = { "i", "n" } },
          ["<Esc>"] = { "close", mode = { "i", "n" } },
          ["<Tab>"] = { "select_and_next", mode = { "i", "n" } },
          ["<S-Tab>"] = { "select_and_prev", mode = { "i", "n" } },
          ["<C-a>"] = { "select_all", mode = { "i", "n" } },
        },
      },
    },
    actions = {
      cycle_layouts = function(p)
        require("config.snacks-picker-layouts").set_next_preferred_layout(p)
      end,
      toggle_cwd = function(p)
        local cwd = vim.fs.normalize((vim.uv or vim.loop).cwd() or ".")
        local current = p:cwd()
        p:set_cwd(current == cwd and vim.fn.getcwd() or cwd)
        p:find()
      end,
    },
    formatters = {
      file = { filename_first = true },
    },
  },
  statuscolumn = { enabled = true },
  words = { enabled = true },
  explorer = { replace_netrw = true },
})

-- Keymaps
vim.keymap.set("n", "<leader>,", function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>bb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep" })
vim.keymap.set("n", "<leader>:", function() Snacks.picker.command_history({}) end, { desc = "Command History" })
vim.keymap.set("n", "<leader><space>", function() Snacks.picker.command_history() end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find Config File" })
vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files({}) end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", function() Snacks.picker.git_files() end, { desc = "Find Git Files" })
vim.keymap.set("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent" })
vim.keymap.set("n", "<leader>fs", function() Snacks.picker.smart() end, { desc = "Smart" })
vim.keymap.set("n", "<leader>gc", function() Snacks.picker.git_log() end, { desc = "Git Log" })
vim.keymap.set("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Git Status" })
vim.keymap.set("n", "<leader>sb", function() Snacks.picker.lines() end, { desc = "Buffer Lines" })
vim.keymap.set("n", "<leader>ss", function() Snacks.picker.lines() end, { desc = "Buffer Lines" })
vim.keymap.set("n", "<leader>sB", function() Snacks.picker.grep_buffers() end, { desc = "Grep Open Buffers" })
vim.keymap.set("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Grep" })
vim.keymap.set("n", "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Visual selection or word" })
vim.keymap.set("n", '<leader>s"', function() Snacks.picker.registers() end, { desc = "Registers" })
vim.keymap.set("n", "<leader>sa", function() Snacks.picker.autocmds() end, { desc = "Autocmds" })
vim.keymap.set("n", "<leader>sC", function() Snacks.picker.commands() end, { desc = "Commands" })
vim.keymap.set("n", "<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Help Pages" })
vim.keymap.set("n", "<leader>sH", function() Snacks.picker.highlights() end, { desc = "Highlights" })
vim.keymap.set("n", "<leader>sj", function() Snacks.picker.jumps() end, { desc = "Jumps" })
vim.keymap.set("n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>sl", function() Snacks.picker.loclist() end, { desc = "Location List" })
vim.keymap.set("n", "<leader>sM", function() Snacks.picker.man() end, { desc = "Man Pages" })
vim.keymap.set("n", "<leader>sm", function() Snacks.picker.marks() end, { desc = "Marks" })
vim.keymap.set("n", "<leader>sR", function() Snacks.picker.resume() end, { desc = "Resume" })
vim.keymap.set("n", "<leader>sq", function() Snacks.picker.qflist() end, { desc = "Quickfix List" })
vim.keymap.set("n", "<leader>uC", function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })
vim.keymap.set("n", "<leader>qp", function() Snacks.picker.projects() end, { desc = "Projects" })

-- LSP picker keymaps are defined in autocmds.lua (LspAttach)
-- They use Snacks picker when available, with fallback to native LSP
