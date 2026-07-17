local M = {}

local function has_snacks()
  local ok, _ = pcall(require, "snacks")
  return ok
end

--- Get the current visual selection
function M.get_visual_selection()
  local mode = vim.fn.mode()
  if mode ~= "v" and mode ~= "V" and mode ~= "\22" then
    return nil
  end
  local vstart = vim.fn.getpos("v")
  local vend = vim.fn.getcurpos()
  local start_line, start_col = vstart[2], vstart[3]
  local end_line, end_col = vend[2], vend[3]
  if start_line > end_line or (start_line == end_line and start_col > end_col) then
    start_line, end_line = end_line, start_line
    start_col, end_col = end_col, start_col
  end
  local lines = vim.api.nvim_buf_get_text(0, start_line - 1, start_col - 1, end_line - 1, end_col, {})
  return table.concat(lines, "\n")
end

--- Get symbol under cursor or visual selection
function M.get_symbol()
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then
    local sel = M.get_visual_selection()
    if sel and sel ~= "" then
      return sel
    end
  end
  return vim.fn.expand("<cword>")
end

--- Find project root (directory containing .codegraph/)
function M.project_root()
  local buf = vim.api.nvim_get_current_buf()
  local buf_path = vim.api.nvim_buf_get_name(buf)
  local dirs = {}

  if buf_path ~= "" then
    table.insert(dirs, vim.fn.fnamemodify(buf_path, ":h"))
  end

  local cwd = vim.fn.getcwd()
  if #dirs == 0 or dirs[1] ~= cwd then
    table.insert(dirs, cwd)
  end

  for _, start_dir in ipairs(dirs) do
    local dir = start_dir
    while dir ~= "/" do
      if vim.fn.isdirectory(dir .. "/.codegraph") == 1 then
        return dir
      end
      local parent = vim.fn.fnamemodify(dir, ":h")
      if parent == dir then
        break
      end
      dir = parent
    end
  end

  return nil
end

--- Check if codegraph is initialized, optionally prompt to init
function M.check_project(auto_prompt)
  local root = M.project_root()
  if not root and auto_prompt ~= false then
    vim.schedule(function()
      local choice = vim.fn.confirm(
        "No .codegraph/ found. Initialize CodeGraph in cwd?",
        "&Yes\n&No",
        1
      )
      if choice == 1 then
        M.init()
      end
    end)
  end
  return root
end

--- Run a codegraph command asynchronously
function M.run(args, opts)
  opts = opts or {}
  local root = opts.cwd or M.project_root() or vim.fn.getcwd()
  local cmd = vim.list_extend({ "codegraph" }, args or {})
  vim.system(cmd, {
    cwd = root,
    text = true,
  }, function(obj)
    vim.schedule(function()
      if obj.code ~= 0 then
        local err = (obj.stderr and obj.stderr ~= "") and obj.stderr or ("exit code " .. obj.code)
        vim.notify("CodeGraph error: " .. err, vim.log.levels.ERROR)
        if opts.on_error then
          opts.on_error(err)
        end
        return
      end
      if opts.on_success then
        opts.on_success(obj.stdout or "")
      end
    end)
  end)
end

--- Parse JSON output from codegraph
local function parse_json(text)
  local ok, data = pcall(vim.json.decode, text)
  if not ok then
    vim.notify("Failed to parse codegraph JSON: " .. tostring(data), vim.log.levels.ERROR)
    return nil
  end
  return data
end

--- Build a snacks picker item from a codegraph symbol entry
local function make_item(entry, root)
  local file = entry.filePath or entry.file or entry.path or ""
  local line = entry.startLine or entry.line or 1
  local col = entry.startColumn or entry.column or 0
  local name = entry.name or entry.qualifiedName or entry.symbol or "unknown"
  local kind = entry.kind or ""
  local text = name .. " " .. kind .. " " .. file

  return {
    text = text,
    file = file,
    pos = { line, col },
    name = name,
    kind = kind,
    entry = entry,
  }
end

--- Format function for codegraph picker items
local function codegraph_format(item, picker)
  local ret = {}
  local name = item.name or "?"
  local kind = item.kind and (" " .. item.kind) or ""
  local file = item.file or ""
  local line = item.pos and item.pos[1] or 1

  local Snacks = package.loaded.snacks
  local icon = "  "
  if Snacks then
    local icons_map =
      Snacks.config and Snacks.config.icons and Snacks.config.icons.kinds or {}
    local capitalized = kind ~= "" and (kind:sub(2, 2):upper() .. kind:sub(3)) or nil
    if capitalized and icons_map[capitalized] then
      icon = icons_map[capitalized] .. " "
    elseif item.kind == "" then
      icon = icons_map.File or "󰈔 "
    end
  end

  ret[#ret + 1] = { icon .. name .. kind, "SnacksPickerLabel" }
  if file ~= "" then
    ret[#ret + 1] = { " → ", "SnacksPickerDelim" }
    ret[#ret + 1] = { file .. ":" .. line, "SnacksPickerFile" }
  end
  return ret
end

--- Open a snacks picker with codegraph items, fallback to vim.ui.select
function M.picker(items, opts)
  opts = opts or {}
  if not has_snacks() then
    vim.ui.select(items, {
      prompt = opts.title or "CodeGraph",
      format_item = function(item)
        return (item.name or "?")
          .. " ["
          .. (item.kind or "?")
          .. "] "
          .. (item.file or "")
          .. ":"
          .. (item.pos and item.pos[1] or "?")
      end,
    }, function(choice)
      if choice and choice.file then
        vim.cmd("edit " .. vim.fn.fnameescape(choice.file))
        if choice.pos then
          pcall(vim.api.nvim_win_set_cursor, 0, { choice.pos[1], choice.pos[2] })
        end
      end
    end)
    return
  end

  Snacks.picker({
    source = opts.source or "codegraph",
    items = items,
    title = opts.title or "CodeGraph",
    format = codegraph_format,
    preview = "file",
    confirm = "file",
    layout = opts.layout or { preset = "default" },
  })
end

--- Query symbols in the codebase
function M.query(query_str, opts)
  opts = opts or {}
  local root = M.check_project()
  if not root then
    return
  end
  M.run({ "query", "--json", query_str }, {
    cwd = root,
    on_success = function(stdout)
      local data = parse_json(stdout)
      if not data then
        return
      end
      local items = {}
      for _, result in ipairs(data) do
        local node = result.node or result
        table.insert(items, make_item(node, root))
      end
      if #items == 0 then
        vim.notify("No results for query: " .. query_str, vim.log.levels.INFO)
        return
      end
      M.picker(items, {
        source = "codegraph_query",
        title = "CodeGraph Query: " .. query_str,
      })
    end,
  })
end

--- Find callers of a symbol
function M.callers(symbol, opts)
  opts = opts or {}
  local root = M.check_project()
  if not root then
    return
  end
  symbol = symbol or M.get_symbol()
  M.run({ "callers", "--json", symbol }, {
    cwd = root,
    on_success = function(stdout)
      local data = parse_json(stdout)
      if not data or not data.callers then
        vim.notify("No callers found for " .. symbol, vim.log.levels.INFO)
        return
      end
      local items = {}
      for _, entry in ipairs(data.callers) do
        table.insert(items, make_item(entry, root))
      end
      if #items == 0 then
        vim.notify("No callers found for " .. symbol, vim.log.levels.INFO)
        return
      end
      M.picker(items, {
        source = "codegraph_callers",
        title = "Callers of " .. symbol,
      })
    end,
  })
end

--- Find callees of a symbol
function M.callees(symbol, opts)
  opts = opts or {}
  local root = M.check_project()
  if not root then
    return
  end
  symbol = symbol or M.get_symbol()
  M.run({ "callees", "--json", symbol }, {
    cwd = root,
    on_success = function(stdout)
      local data = parse_json(stdout)
      if not data or not data.callees then
        vim.notify("No callees found for " .. symbol, vim.log.levels.INFO)
        return
      end
      local items = {}
      for _, entry in ipairs(data.callees) do
        table.insert(items, make_item(entry, root))
      end
      if #items == 0 then
        vim.notify("No callees found for " .. symbol, vim.log.levels.INFO)
        return
      end
      M.picker(items, {
        source = "codegraph_callees",
        title = "Callees of " .. symbol,
      })
    end,
  })
end

--- Analyze impact of changing a symbol
function M.impact(symbol, opts)
  opts = opts or {}
  local root = M.check_project()
  if not root then
    return
  end
  symbol = symbol or M.get_symbol()
  M.run({ "impact", "--json", symbol }, {
    cwd = root,
    on_success = function(stdout)
      local data = parse_json(stdout)
      if not data or not data.affected then
        vim.notify("No impact data for " .. symbol, vim.log.levels.INFO)
        return
      end
      local items = {}
      for _, entry in ipairs(data.affected) do
        table.insert(items, make_item(entry, root))
      end
      if #items == 0 then
        vim.notify("No affected symbols for " .. symbol, vim.log.levels.INFO)
        return
      end
      M.picker(items, {
        source = "codegraph_impact",
        title = "Impact: " .. symbol .. " (" .. (data.nodeCount or #items) .. " nodes)",
      })
    end,
  })
end

--- Show node details with source and trail in a float
function M.node(symbol, opts)
  opts = opts or {}
  local root = M.check_project()
  if not root then
    return
  end
  symbol = symbol or M.get_symbol()
  M.run({ "node", symbol }, {
    cwd = root,
    on_success = function(stdout)
      local lines = vim.split(stdout, "\n")
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.bo[buf].filetype = "markdown"
      vim.bo[buf].modifiable = false
      vim.bo[buf].bufhidden = "wipe"

      local width = math.min(80, vim.o.columns - 8)
      local height = math.min(30, #lines + 2, vim.o.lines - 4)
      local row = math.floor((vim.o.lines - height) / 2)
      local col = math.floor((vim.o.columns - width) / 2)

      local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
        title = " CodeGraph: " .. symbol .. " ",
        title_pos = "center",
      })

      for _, key in ipairs({ "q", "<Esc>", "<CR>" }) do
        vim.keymap.set("n", key, function()
          pcall(vim.api.nvim_win_close, win, true)
        end, { buffer = buf, nowait = true, silent = true })
      end

      vim.keymap.set("n", "gc", function()
        pcall(vim.api.nvim_win_close, win, true)
        vim.schedule(function()
          M.callers(symbol)
        end)
      end, { buffer = buf, desc = "Show callers", nowait = true, silent = true })

      vim.keymap.set("n", "gC", function()
        pcall(vim.api.nvim_win_close, win, true)
        vim.schedule(function()
          M.callees(symbol)
        end)
      end, { buffer = buf, desc = "Show callees", nowait = true, silent = true })

      vim.keymap.set("n", "gi", function()
        pcall(vim.api.nvim_win_close, win, true)
        vim.schedule(function()
          M.impact(symbol)
        end)
      end, { buffer = buf, desc = "Show impact", nowait = true, silent = true })
    end,
  })
end

--- Show codegraph status
function M.status(opts)
  opts = opts or {}
  local root = M.project_root()
  if not root then
    vim.notify("No .codegraph/ found in project", vim.log.levels.WARN)
    return
  end
  M.run({ "status" }, {
    cwd = root,
    on_success = function(stdout)
      local lines = vim.split(stdout, "\n")
      vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
    end,
  })
end

--- Initialize codegraph in project
function M.init(opts)
  opts = opts or {}
  local cwd = opts.cwd or vim.fn.getcwd()
  vim.notify("Initializing CodeGraph in " .. cwd .. "...", vim.log.levels.INFO)
  M.run({ "init" }, {
    cwd = cwd,
    on_success = function(stdout)
      vim.notify("CodeGraph initialized!\n" .. stdout, vim.log.levels.INFO)
    end,
  })
end

--- Sync incremental changes
function M.sync(opts)
  opts = opts or {}
  local root = M.project_root()
  if not root then
    vim.notify("No .codegraph/ found. Run :CodegraphInit first.", vim.log.levels.WARN)
    return
  end
  vim.notify("Syncing CodeGraph index...", vim.log.levels.INFO)
  M.run({ "sync" }, {
    cwd = root,
    on_success = function(stdout)
      vim.notify("CodeGraph synced!\n" .. stdout, vim.log.levels.INFO)
    end,
  })
end

--- Rebuild full index
function M.reindex(opts)
  opts = opts or {}
  local root = M.project_root()
  if not root then
    vim.notify("No .codegraph/ found. Run :CodegraphInit first.", vim.log.levels.WARN)
    return
  end
  vim.notify("Re-indexing CodeGraph...", vim.log.levels.INFO)
  M.run({ "index" }, {
    cwd = root,
    on_success = function(stdout)
      vim.notify("CodeGraph re-indexed!\n" .. stdout, vim.log.levels.INFO)
    end,
  })
end

--- Explore an area with a query (shows rich source in float)
function M.explore(query_str, opts)
  opts = opts or {}
  local root = M.check_project()
  if not root then
    return
  end
  query_str = query_str or M.get_symbol()
  M.run({ "explore", query_str }, {
    cwd = root,
    on_success = function(stdout)
      local lines = vim.split(stdout, "\n")
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.bo[buf].filetype = "markdown"
      vim.bo[buf].modifiable = false
      vim.bo[buf].bufhidden = "wipe"

      local width = math.min(100, vim.o.columns - 8)
      local height = math.min(40, #lines + 2, vim.o.lines - 4)
      local row = math.floor((vim.o.lines - height) / 2)
      local col = math.floor((vim.o.columns - width) / 2)

      local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
        title = " Explore: " .. query_str .. " ",
        title_pos = "center",
      })

      for _, key in ipairs({ "q", "<Esc>", "<CR>" }) do
        vim.keymap.set("n", key, function()
          pcall(vim.api.nvim_win_close, win, true)
        end, { buffer = buf, nowait = true, silent = true })
      end
    end,
  })
end

-- Register user commands
vim.api.nvim_create_user_command("CodegraphInit", function()
  M.init()
end, { desc = "Initialize CodeGraph in project" })

vim.api.nvim_create_user_command("CodegraphSync", function()
  M.sync()
end, { desc = "Sync CodeGraph index" })

vim.api.nvim_create_user_command("CodegraphReindex", function()
  M.reindex()
end, { desc = "Re-index CodeGraph project" })

vim.api.nvim_create_user_command("CodegraphStatus", function()
  M.status()
end, { desc = "Show CodeGraph status" })

vim.api.nvim_create_user_command("CodegraphQuery", function(args)
  M.query(args.args)
end, { nargs = 1, desc = "Query CodeGraph symbols" })

vim.api.nvim_create_user_command("CodegraphCallers", function(args)
  M.callers(args.args ~= "" and args.args or nil)
end, { nargs = "?", desc = "Find callers of symbol" })

vim.api.nvim_create_user_command("CodegraphCallees", function(args)
  M.callees(args.args ~= "" and args.args or nil)
end, { nargs = "?", desc = "Find callees of symbol" })

vim.api.nvim_create_user_command("CodegraphImpact", function(args)
  M.impact(args.args ~= "" and args.args or nil)
end, { nargs = "?", desc = "Analyze impact of symbol" })

vim.api.nvim_create_user_command("CodegraphNode", function(args)
  M.node(args.args ~= "" and args.args or nil)
end, { nargs = "?", desc = "Show CodeGraph node details" })

vim.api.nvim_create_user_command("CodegraphExplore", function(args)
  M.explore(args.args ~= "" and args.args or nil)
end, { nargs = "?", desc = "Explore area in CodeGraph" })

return M
