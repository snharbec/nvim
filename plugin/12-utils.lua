-- Install and load plugins
vim.pack.add({
  "https://codeberg.org/andyg/leap.nvim.git",
  'https://github.com/sphamba/smear-cursor.nvim',
  'https://github.com/aaronik/treewalker.nvim',
  'https://github.com/abecodes/tabout.nvim',
  'https://github.com/sbulav/jira-oil.nvim',
  'https://github.com/stevearc/conform.nvim'
})

-- Ensure plugins are loaded with packadd
vim.cmd.packadd('leap.nvim')
vim.cmd.packadd('smear-cursor.nvim')
vim.cmd.packadd('treewalker.nvim')
vim.cmd.packadd('tabout.nvim')
vim.cmd.packadd('conform.nvim')
vim.cmd.packadd('jira-oil.nvim')

-- Leap
local ok_leap, leap = pcall(require, "leap")
if ok_leap then
  vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
  vim.keymap.set('n', 'S', '<Plug>(leap-from-window)') 
end

-- Smear cursor
local ok_smear, smear = pcall(require, "smear-cursor")
if ok_smear then
  smear.setup()
end

-- Treewalker
local ok_tree, treewalker = pcall(require, "treewalker")
if ok_tree then
  treewalker.setup()
end

-- Tabout
local ok_tabout, tabout = pcall(require, "tabout")
if ok_tabout then
  tabout.setup({
    tabkey = "<Tab>",
    backwards_tabkey = "<S-Tab>",
    act_as_tab = true,
    act_as_shift_tab = false,
    default_tab = "<C-t>",
    default_shift_tab = "<C-d>",
    completion = false,
    tabouts = {
      { open = "'", close = "'" },
      { open = '"', close = '"' },
      { open = '`', close = '`' },
      { open = '(', close = ')' },
      { open = '[', close = ']' },
      { open = '{', close = '}' },
      { open = '<', close = '>' },
    },
    ignore_beginning = true,
    exclude = {},
    stop_order = { "forward", "back" },
  })
end

-- Conform
local ok_conform, conform = pcall(require, "conform")
if ok_conform then
  conform.setup({
    formatters_by_ft = {
      markdown = { "prettier"},
    },
  })
end

-- JIRA OIL
local ok_jira, jira = pcall(require, "jira-oil")
if ok_jira then
  jira.setup({
    keys = { 
      {
        "<leader>jj",
        function()
          require("jira-oil").open("all")
        end,
        desc = "JiraOil: all",
      },
      {
        "<leader>js",
        function()
          require("jira-oil").open("sprint")
        end,
        desc = "JiraOil: sprint",
      },
      {
        "<leader>jc",
        function()
          require("jira-oil.scratch").open_new()
        end,
        desc = "JiraOil: create issue",
      },
    },
    cli = {
      cmd = "jira",
      timeout = 10000,
      cache = {
        enabled = true,
        ttl_ms = {
          sprint_issues = 5000,
          backlog_issues = 5000,
          issue = 15000,
          epics = 30000,
        },
      },
      issues = {
        columns = { "key", "assignee", "status", "summary", "labels" },
        team_jql = "",          -- e.g. "assignee in membersOf('TEAM_JQL')"
        exclude_jql = "issuetype != Epic",
        status_jql = "",        -- e.g. "status != Closed"
      },
      epics = {
        args = { "issue", "list", "--type", "Epic" },
        columns = { "key", "summary", "status" },
        filters = { "-s~done", "-s~closed" },
        order_by = "created",
        prefill_search = "",
      },
      epic_issues = {
        args = { "issue", "list" },
        columns = { "type", "key", "assignee", "status", "summary", "labels" },
        filters = { "-s~done", "-s~closed" },
        order_by = "status",
        prefill_search = "",
      },
    },

    view = {
      columns = {
        { name = "status", width = 15 },
        { name = "assignee", width = 15 },
        { name = "summary" },
        { name = "labels", width = 20 },
      },
      key_width = 12,
      default_sort = "key",
      show_winbar = true,
      sections = {
        show_count = true,
        sprint_label = "Sprint",
        backlog_label = "Backlog",
      },
      status_icons = {
        ["Open"]        = "\u{f10c} ",
        ["To Do"]       = "\u{f10c} ",
        ["In Progress"] = "\u{f144} ",
        ["In Review"]   = "\u{f06e} ",
        ["Done"]        = "\u{f058} ",
        ["Closed"]      = "\u{f058} ",
        ["Blocked"]     = "\u{f05e} ",
        default          = "\u{f111} ",
      },
      type_icons = {
        Task         = "\u{f0ae} ",
        Story        = "\u{f02d} ",
        Initiative         = "\u{f0e7} ",
        Epic         = "\u{f0e7} ",
        ["Sub-task"] = "\u{f0ae} ",
        Bug          = "\u{f188} ",
        Improvement  = "\u{f0d0} ",
        Feature      = "\u{f0eb} ",
        default      = "\u{f016} ",
      },
    },

    keymaps = {
      ["g?"] = { "actions.show_help", mode = "n" },
      ["gR"] = { "actions.reset", mode = "n" },
      ["<CR>"] = "actions.select",
      ["<C-c>"] = { "actions.create", mode = "n" },
      ["gB"] = { "actions.open_in_browser", mode = "n" },
      ["<C-y>"] = { "actions.yank_issue_key", mode = { "n", "v" } },
      ["dd"] = { "actions.queue_removal", mode = "n" },
      [">>"] = { "actions.move_to_sprint", mode = "n" },
      ["<<"] = { "actions.move_to_backlog", mode = "n" },
      ["ga"] = { "actions.filter_by_assignee", mode = "n" },
      ["gS"] = { "actions.filter_by_status", mode = "n" },
      ["gp"] = { "actions.filter_by_project", mode = "n" },
      ["g/"] = { "actions.filter_prompt", mode = "n" },
      ["gu"] = { "actions.clear_filters", mode = "n" },
      ["-"] = { "actions.parent_view", mode = "n" },
      ["p"] = { "actions.paste_after", mode = "n" },
      ["P"] = { "actions.paste_before", mode = "n" },
      ["<M-r>"] = { "actions.refresh", mode = "n" },
      ["<C-q>"] = { "actions.close", mode = "n" },
      ["<C-s>"] = { "actions.save", mode = "n" },
    },
    keymaps_issue = {
      ["g?"] = { "actions.show_help", mode = { "n", "i" } },
      ["gR"] = { "actions.reset", mode = { "n", "i" } },
      ["<C-e>"] = { "actions.pick_epic", mode = { "n", "i" } },
      ["<C-o>"] = { "actions.pick_components", mode = { "n", "i" } },
      ["gB"] = { "actions.open_in_browser", mode = { "n", "i" } },
      ["<C-y>"] = { "actions.yank_issue_key", mode = { "n", "i" } },
      ["<C-q>"] = { "actions.close", mode = { "n", "i" } },
      ["<C-s>"] = { "actions.save", mode = { "n", "i" } },
    },
    use_default_keymaps = true,

    keymaps_help = {
      border = nil,
      show_title = true,
      show_footer = true,
      key_width = 18,
      separator = " \u{2502} ",
      max_width_ratio = 0.9,
      max_height_ratio = 0.8,
    },

    defaults = {
      project = vim.env.JIRA_PROJECT or "RMS",
      assignee = vim.env.JIRA_USER or vim.env.JIRA_ASSIGNEE or "HAR",
      issue_type = "Story",
      status = "Open",
    },

    -- Optional: set this only if your Jira tenant uses a custom epic field
    epic_field = "",

    create = {
      available_components = {
        "Backend",
        "Frontend",
        "API",
      },
    },
  })
end
