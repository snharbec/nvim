vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })
vim.cmd.packadd('mini.nvim')

require("mini.ai").setup({
  custom_textobjects = nil,
  mappings = {
    around = 'a',
    inside = 'i',
    around_next = 'an',
    inside_next = 'in',
    around_last = 'al',
    inside_last = 'il',
    goto_left = 'g[',
    goto_right = 'g]',
  },
  n_lines = 50,
  search_method = 'cover_or_next',
})

require("mini.cursorword").setup({
  delay = 100,
})

-- mini.clue - which-key replacement
local miniclue = require('mini.clue')
miniclue.setup({
  triggers = {
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },
    { mode = 'i', keys = '<C-x>' },
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },
    { mode = 'n', keys = "'" },
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = "'" },
    { mode = 'x', keys = '`' },
    { mode = 'n', keys = '"' },
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },
    { mode = 'n', keys = '<C-w>' },
    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },
  },
  clues = {
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
    { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
    { mode = 'n', keys = '<Leader>c', desc = '+Code' },
    { mode = 'n', keys = '<Leader>d', desc = '+Delete' },
    { mode = 'n', keys = '<Leader>f', desc = '+File/Find' },
    { mode = 'n', keys = '<Leader>g', desc = '+Git' },
    { mode = 'n', keys = '<Leader>n', desc = '+Notes' },
    { mode = 'n', keys = '<Leader>s', desc = '+Search' },
    { mode = 'n', keys = '<Leader>t', desc = '+Toggle' },
    { mode = 'n', keys = '<Leader>w', desc = '+Windows' },
    { mode = 'n', keys = '<Leader>y', desc = '+Yank' },
    { mode = 'n', keys = '<Leader>S', desc = '+Session' },
  },
  window = {
    config = { width = 'auto', border = 'none' },
    delay = 500,
  },
})

-- Session management
local sessions = require("mini.sessions")
local session_dir = vim.fn.stdpath("data") .. "/sessions"
vim.fn.mkdir(session_dir, "p")

sessions.setup({
  autowrite = true,
  directory = session_dir,
  force = { read = false, write = true, delete = false },
})

local function get_session_name()
  local cwd = vim.fn.getcwd()
  return cwd:gsub("[/\\]", "_"):gsub(":", "_"):gsub("%.", "_")
end

vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("session-auto-restore", { clear = true }),
  callback = function()
    if vim.fn.argc() > 0 then return end
    local session_name = get_session_name()
    local session_file = session_dir .. "/" .. session_name .. ".vim"
    if vim.fn.filereadable(session_file) == 1 then
      vim.schedule(function()
        local choice = vim.fn.confirm("Restore session for " .. vim.fn.getcwd() .. "?", "&Yes\n&No", 1)
        if choice == 1 then sessions.read(session_name) end
      end)
    end
  end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("session-auto-save", { clear = true }),
  callback = function()
    sessions.write(get_session_name())
  end,
})

vim.api.nvim_create_user_command("SessionSave", function()
  sessions.write(get_session_name())
  vim.notify("Session saved", vim.log.levels.INFO)
end, { desc = "Save current session" })

vim.api.nvim_create_user_command("SessionLoad", function()
  local name = get_session_name()
  if sessions.detected[name] then sessions.read(name) end
end, { desc = "Load session" })

vim.api.nvim_create_user_command("SessionDelete", function()
  sessions.delete(get_session_name())
end, { desc = "Delete session" })

vim.api.nvim_create_user_command("SessionList", function()
  local detected = sessions.detected
  if vim.tbl_isempty(detected) then
    vim.notify("No sessions found", vim.log.levels.INFO)
    return
  end
  local names = {}
  for name, _ in pairs(detected) do table.insert(names, name) end
  table.sort(names)
  print("Available sessions:")
  for _, name in ipairs(names) do print("  - " .. name) end
end, { desc = "List sessions" })

vim.keymap.set("n", "<leader>Ss", "<cmd>SessionSave<cr>", { desc = "Save session" })
vim.keymap.set("n", "<leader>Sl", "<cmd>SessionLoad<cr>", { desc = "Load session" })
vim.keymap.set("n", "<leader>Sd", "<cmd>SessionDelete<cr>", { desc = "Delete session" })
vim.keymap.set("n", "<leader>SL", "<cmd>SessionList<cr>", { desc = "List sessions" })
