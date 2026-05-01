local function open_smart()
  local line = vim.api.nvim_get_current_line()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))

  -- 1. Check if cursor is inside a wiki link [[LINK]]
  local start_pos, finish_pos = 1, #line
  local name = nil
  while start_pos <= finish_pos do
    local s, e = line:find("%[%[.-%]%]", start_pos)
    if not s then break end
    if col >= s - 1 and col <= e - 1 then
      name = line:sub(s + 2, e - 2)
      break
    end
    start_pos = e + 1
  end

  if name then
    if name:find("#") then
      Snacks.picker.lsp_definitions()
      return
    end

    local cwd = vim.fn.getcwd()
    local notes_dir = vim.env.NOTE_SEARCH_DIR or "~/.local/share/notes"
    notes_dir = vim.fn.expand(notes_dir)

    local variations = {
      cwd .. "/" .. name,
      cwd .. "/" .. name .. ".md",
      notes_dir .. "/" .. name .. ".md",
    }

    for _, target in ipairs(variations) do
      if vim.fn.filereadable(target) == 1 then
        vim.cmd("edit " .. vim.fn.fnameescape(target))
        return
      end
    end

    local matches = vim.fn.glob(notes_dir .. "/**/" .. name .. ".md", 0, 1)
    if #matches == 1 then
      vim.cmd("edit " .. vim.fn.fnameescape(matches[1]))
      return
    elseif #matches > 1 then
      vim.ui.select(matches, {
        prompt = "Note '" .. name .. "' found in multiple locations:",
        format_item = function(item)
          return vim.fn.fnamemodify(item, ":~:.")
        end,
      }, function(choice)
        if choice then
          vim.cmd("edit " .. vim.fn.fnameescape(choice))
        end
      end)
      return
    end

    vim.notify("Note not found: " .. name)
    return
  end

  -- Extract the token under cursor by scanning backwards and forwards
  -- Includes alphanumeric, underscore, -, ., :, /, @ (covers words, paths, URLs, JIRA issues)
  local token_chars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-.:/@"

  local i = col + 1  -- Vim column is 1-based for find/strfind
  -- Scan forward
  local j = i
  while j <= #line and token_chars:find(line:sub(j, j), 1, true) do
    j = j + 1
  end
  -- Scan backward
  local k = i
  while k > 1 and token_chars:find(line:sub(k - 1, k - 1), 1, true) do
    k = k - 1
  end

  local candidate = line:sub(k, j - 1)

  -- 2. URL → open in browser (check before paths since URLs contain "/")
  local url = candidate:match("^https?://")
  if url then
    local cmd
    if vim.fn.has("mac") == 1 then
      cmd = { "open", candidate }
    elseif vim.fn.executable("xdg-open") == 1 then
      cmd = { "xdg-open", candidate }
    elseif vim.fn.executable("firefox") == 1 then
      cmd = { "firefox", candidate }
    else
      vim.notify("No browser found to open: " .. candidate, vim.log.levels.WARN)
      return
    end
    os.execute(vim.fn.shellescape(cmd[1]) .. " " .. vim.fn.shellescape(cmd[2]) .. " >/dev/null 2>&1 &")
    return
  end

  -- 3. Word with path separator → open file at full path
  if candidate:find("/") then
    local expanded = vim.fn.expand(candidate)
    if vim.fn.filereadable(expanded) == 1 then
      vim.cmd("edit " .. vim.fn.fnameescape(expanded))
    else
      vim.notify("File not found: " .. expanded)
    end
    return
  end

  -- 4. JIRA issue PROJ-123 → open JIRA URL
  local jira = candidate:match("^([A-Z]+-[0-9]+)$")
  if jira then
    local jira_url = vim.env.JIRA_URL or "https://harjira.atlassian.net"
    local target = jira_url .. "/browse/" .. jira
    local cmd
    if vim.fn.has("mac") == 1 then
      cmd = { "open", target }
    elseif vim.fn.executable("xdg-open") == 1 then
      cmd = { "xdg-open", target }
    else
      cmd = { "open", target }
    end
    os.execute(vim.fn.shellescape(cmd[1]) .. " " .. vim.fn.shellescape(cmd[2]) .. " >/dev/null 2>&1 &")
    return
  end

  -- 5. Plain word → search for file in cwd using fd/fdfind
  if candidate and candidate ~= "" then
    local bin = vim.fn.executable("fdfind") == 1 and "fdfind"
      or vim.fn.executable("fd") == 1 and "fd"
    if not bin then
      vim.notify("fd not found, cannot search", vim.log.levels.WARN)
      return
    end
    local search_dir = vim.fn.getcwd()
    local cmd = bin .. " -s -t f "
      .. vim.fn.shellescape(candidate) .. " "
      .. vim.fn.shellescape(search_dir)
    local handle = io.popen(cmd)
    if handle then
      local results = {}
      for line in handle:lines() do
        table.insert(results, line)
      end
      handle:close()

      if #results == 1 then
        vim.cmd("edit " .. vim.fn.fnameescape(results[1]))
        return
      elseif #results > 1 then
        vim.ui.select(results, {
          prompt = "Open '" .. candidate .. "':",
          format_item = function(item)
            return vim.fn.fnamemodify(item, ":p")
          end,
        }, function(choice)
          if choice then
            vim.cmd("edit " .. vim.fn.fnameescape(choice))
          end
        end)
        return
      end
      vim.notify("No file found: " .. candidate, vim.log.levels.WARN)
      return
    end
  end

  vim.notify("Nothing to open", vim.log.levels.WARN)
end

vim.keymap.set("n", "<leader>o", open_smart, { desc = "Open smart" })
