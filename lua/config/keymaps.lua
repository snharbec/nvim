-- Basic keymaps

local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize windows
map("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Navigate buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>nohlsearch<CR><Esc>", { desc = "Escape and clear hlsearch" })

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- New file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- Quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Terminal
map("n", "<leader>ft", "<cmd>terminal<cr>", { desc = "Terminal" })

-- Insert mode helpers
map("i", "<C-BS>", "<C-w>", { desc = "Delete word" })
map("i", "<C-h>", "<C-w>", { desc = "Delete word" })
map("i", "<M-BS>", "<C-w>", { desc = "Delete word" })

-- Leader keymaps
map("n", "<leader>gg", ":Neogit<CR>", { desc = "Open Neogit" })
map("n", "<leader>ss", function()
  require("snacks").picker.lines()
end, { desc = "Search lines" })

-- Buffer management
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>bD", "<cmd>bdelete!<cr>", { desc = "Delete buffer (force)" })
map("n", "<leader>bw", "<cmd>bwipeout<cr>", { desc = "Wipeout buffer" })
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>bN", "<cmd>enew<cr>", { desc = "New buffer" })
map("n", "<leader>bl", "<cmd>buffers<cr>", { desc = "List buffers" })
map("n", "<leader>bf", function()
  require("snacks").picker.buffers()
end, { desc = "Find buffer" })

-- Formatting
vim.keymap.set({ "n", "v" }, "<leader>bF", function()
  require("conform").format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 500,
  })
end, { desc = "Format Markdown/File" })

-- Trouble
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
map("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
map(
  "n",
  "<leader>xl",
  "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
  { desc = "LSP Definitions / references (Trouble)" }
)
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })

-- CodeGraph integration (LSP-like code intelligence)
map("n", "<leader>cgq", function()
  vim.ui.input({ prompt = "CodeGraph query: " }, function(input)
    if input then
      require("config.codegraph").query(input)
    end
  end)
end, { desc = "CodeGraph query" })

map("n", "<leader>cgc", function()
  require("config.codegraph").callers()
end, { desc = "CodeGraph callers" })

map("n", "<leader>cgC", function()
  require("config.codegraph").callees()
end, { desc = "CodeGraph callees" })

map("n", "<leader>cgi", function()
  require("config.codegraph").impact()
end, { desc = "CodeGraph impact" })

map("n", "<leader>cgn", function()
  require("config.codegraph").node()
end, { desc = "CodeGraph node" })

map("n", "<leader>cgs", function()
  require("config.codegraph").status()
end, { desc = "CodeGraph status" })

map("n", "<leader>cgI", function()
  require("config.codegraph").init()
end, { desc = "CodeGraph init" })

map("n", "<leader>cgS", function()
  require("config.codegraph").sync()
end, { desc = "CodeGraph sync" })

map("n", "<leader>cgR", function()
  require("config.codegraph").reindex()
end, { desc = "CodeGraph re-index" })

map("n", "<leader>cge", function()
  vim.ui.input({ prompt = "CodeGraph explore: " }, function(input)
    if input then
      require("config.codegraph").explore(input)
    end
  end)
end, { desc = "CodeGraph explore" })
