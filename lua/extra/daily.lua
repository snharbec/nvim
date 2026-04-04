-- Stefan Notes System. It has the following functions
-- - Supports different types of notes, which can be searched for or created
-- - Creation of new note uses a predefined template
-- - Insert of links to specific note types
local M = {}

M.sub = "<leader>n"
M.note_dir = vim.fn.expand("~/Documents/notes/")
M.template_dir = M.note_dir .. "templates/"
M.suffix = ".md"

local Snacks = require("snacks")

-- Function to search for an note of a specific type and insert that as a link
-- at the current cursor position
M.insert_link_to_note_type = function(sub_element)
  local cwd = M.note_dir .. "/" .. sub_element
  Snacks.picker.files({
    cwd = cwd,
    title = "Search " .. sub_element,
    depth = 1,
    matcher = {
      fuzzy = true,
      frecency = true,
      history_bonus = true,
      ignore_case = true,
    },
    file = {
      filename_first = true,
      git_status = false,
      truncate = "center",
    },
    actions = {
      confirm = function(picker, item)
        picker:close()
        local element = item.file
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        local text = "[[" .. element .. "]]"
        vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { text .. "  " })
        vim.api.nvim_win_set_cursor(0, { row, col + #text + 5 })
        vim.schedule(function()
          vim.cmd("startinsert")
        end)
      end,
    },
  })
end

M.find_element = function(sub_element)
  local cwd = M.note_dir .. "/" .. sub_element
  Snacks.picker.files({
    cwd = cwd,
    title = "Search " .. sub_element,
    depth = 1,
    matcher = {
      fuzzy = true,
      frecency = true,
      history_bonus = true,
      ignore_case = true,
    },
    file = {
      filename_first = true,
      git_status = false,
      truncate = "center",
    },
    actions = {
      confirm = function(picker, item)
        picker:close()
        local element = item.file
        element = string.gsub(element, M.suffix, "")
        local orig_name = element
        local simpleName = string.gsub(element, "_", " ")
        element = string.lower(element)
        local name_of_note = vim.fn.inputdialog("Name of note for " .. element)
        local filename_of_note = string.gsub(name_of_note, " ", "_")
        filename_of_note = string.lower(filename_of_note)
        element = string.gsub(element, " ", "_")
        local date = os.date("%Y%m%d")
        local file_path = M.note_dir
          .. "/"
          .. sub_element
          .. "/"
          .. element
          .. "/"
          .. date
          .. "-"
          .. filename_of_note
          .. ".md"
        if vim.fn.filereadable(file_path) == 1 then
          vim.cmd("edit " .. file_path)
          return
        end
        M.create_note_buffer(name_of_note, "note", file_path, simpleName, orig_name)
      end,
    },
  })
end

M.get_note_filename = function(basename, sub_dir, dayPrefix, dayStructure)
  local file_name = basename
  local today = os.date("%Y%m%d")
  if dayPrefix == 1 then
    local date = today
    file_name = date .. "-" .. basename
  end
  local suffix_length = #M.suffix
  if not vim.endswith(file_name, M.suffix) then
    file_name = file_name .. M.suffix
  end
  -- Construct the full path with an optional date subfolder
  local file_path = M.note_dir .. sub_dir .. "/"
  if dayStructure == 1 then
    file_path = file_path .. os.date("%Y") .. "/" .. os.date("%b") .. "/" .. file_name
  else
    file_path = file_path .. file_name
  end
  return file_path
end

M.create_new_element = function(basename, sub_element, dayPrefix, dayStructure)
  -- print("basename=" .. basename)
  if basename == "" then
    print("No basename provided")
    return
  end
  local file_path = M.get_note_filename(basename, sub_element, dayPrefix, dayStructure)
  -- Check if file already exists to prevent overwriting
  if vim.fn.filereadable(file_path) == 1 then
    vim.cmd("edit " .. file_path)
    return
  end
  M.create_note_buffer(basename, sub_element, file_path)
end

M.find_or_create_note = function(sub_element, dayPrefix, dayStructure, all)
  local cwd = M.note_dir .. "/" .. sub_element
  if all == 1 then
    cwd = M.note_dir
  end
  -- builtin.find_files({
  Snacks.picker.files({
    cwd = cwd,
    title = "Search Notes (or type new name and create with Alt-e)",
    matcher = {
      fuzzy = false,
      frecency = true,
      history_bonus = true,
      ignore_case = true,
    },
    file = {
      filename_first = true,
      git_status = false,
      truncate = "center",
    },
    win = {
      input = {
        keys = {
          ["<a-e>"] = { "create_new", mode = { "i", "n" } },
        },
      },
    },
    actions = {
      confirm = function(picker, item)
        local items = picker:items()
        if #items == 0 then
          local user_input = picker.finder.filter.pattern
          picker:close()
          -- Ask the user if he would like to create that note
          local choice = vim.fn.confirm("Do you want to create " .. user_input .. "?", "&Yes\n&No", 2)
          if choice == 1 then
            M.create_new_element(user_input, sub_element, dayPrefix, dayStructure)
          end
          return
        end
        picker:close()
        if item then
          vim.api.nvim_command("edit " .. item.file)
        end
      end,
      create_new = function(picker)
        local content = picker.finder.filter.pattern
        picker:close()
        M.create_new_element(content, sub_element, dayPrefix, dayStructure)
      end,
    },
  })
end

M.insert_template = function(buffer, template_file, name, NAME, link, linkText)
  local today = os.date("%Y-%m-%d")
  local yesterday = os.date("%Y-%m-%d", os.time() - 86400)
  local tomorrow = os.date("%Y-%m-%d", os.time() + 86400)
  local last_week = os.date("%Y-%m-%d", os.time() - (7 * 86400))
  local next_week = os.date("%Y-%m-%d", os.time() + (7 * 86400))
  if not vim.fn.filereadable(template_file) then
    vim.api.nvim_err_writeln("Unable to find template " .. template_file)
  else
    local lines = vim.fn.readfile(template_file)
    for i, line in ipairs(lines) do
      line = line:gsub("__name__", name)
      line = line:gsub("__NAME__", NAME)
      line = line:gsub("__TODAY__", today)
      line = line:gsub("__TOMORROW__", tomorrow)
      line = line:gsub("__YESTERDAY__", yesterday)
      line = line:gsub("__LAST_WEEK__", last_week)
      line = line:gsub("__NEXT_WEEK__", next_week)

      if linkText then
        line = line:gsub("__LINK__", linkText)
        line = line:gsub("__link__", link)
      end
      lines[i] = line
    end
    vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
  end
end

M.position_cursor = function(buffer, pattern)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for i, line in ipairs(lines) do
    local start_col, end_col = string.find(line, pattern)
    if start_col then
      lines[i] = string.gsub(line, pattern, " ")
      vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
      vim.api.nvim_win_set_cursor(0, { i, start_col - 1 })
      return
    end
  end
end

M.create_note_buffer = function(basename, sub_element, file_path, linkText, link)
  local buffer = vim.fn.bufnr(file_path)
  if buffer ~= -1 then
    vim.api.nvim_set_current_buf(buffer)
    return
  end
  buffer = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_name(buffer, file_path)
  vim.api.nvim_buf_set_option(buffer, "filetype", "markdown")
  -- Crate some variables to replace inside the buffer
  local name = basename
  name = string.lower(name)
  name = string.gsub(name, " ", "_")
  local NAME = basename
  if vim.endswith(NAME, M.suffix) then
    NAME = string.sub(NAME, -#M.suffix)
  end

  local template_file = M.template_dir .. "/" .. sub_element .. M.suffix
  M.insert_template(buffer, template_file, name, NAME, link, linkText)
  vim.api.nvim_set_current_buf(buffer)
  M.position_cursor(buffer, "__CURSOR__")
  vim.cmd("startinsert")
  print("Created new note: " .. file_path)
end

local function get_selection()
  local vstart = vim.fn.getpos("v")
  local vend = vim.fn.getpos(".")
  local line_start = vstart[2]
  local line_end = vend[2]

  local min = math.min(line_start, line_end)
  local max = math.max(line_start, line_end)

  local lines = vim.fn.getline(min, max)
  for i, line in ipairs(lines) do
    print(i, " Orig:", line)
  end
  return lines
end

--
-- Save the old position file name
-- Save the old file type
-- Save any marked text
local save_original_position = function()
  M.abs_path = vim.api.nvim_buf_get_name(0)
  M.file_type = vim.bo.filetype
  M.selected = get_selection()
  for i, line in ipairs(M.selected) do
    print(i, ":", line)
  end
end

M.create_or_open_daily_note = function(dayDifference)
  local day = os.date("%Y-%m-%d", os.time() + dayDifference * 86400)
  save_original_position()
  M.create_new_element(day, "daily", 0, 1)
end

M.insert_link_to_file = function()
  if M.abs_path and #M.abs_path > 0 then
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local text = "[[" .. M.abs_path .. "]]"
    vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { text .. "  " })
    vim.api.nvim_win_set_cursor(0, { row, col + #text + 5 })
    vim.cmd("startinsert")
  end
end

M.insert_selection = function()
  if M.selected and #M.selected > 0 then
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    row = row - 1
    local text = { "```" .. M.file_type }
    text = vim.list_extend(text, M.selected)
    table.insert(text, "```")
    table.insert(text, "")
    vim.api.nvim_buf_set_text(0, row, col, row, col, text)
    vim.api.nvim_win_set_cursor(0, { row, col + #text + 5 })
  else
    print("No selection")
  end
  vim.cmd("startinsert")
end

M.setup = function()
  vim.api.nvim_create_user_command("HarToday", function()
    M.create_or_open_daily_note(0)
  end, {})
  vim.api.nvim_create_user_command("HarTomorrow", function()
    M.create_or_open_daily_note(1)
  end, {})
  vim.api.nvim_create_user_command("HarYesterday", function()
    M.create_or_open_daily_note(-1)
  end, {})
  local function is_mapped(mode, lhs)
    return vim.fn.maparg(lhs, mode) ~= ""
  end
  if is_mapped("n", M.sub) then
    vim.keymap.del("n", M.sub)
  end
  local function nmap(key, command, desc)
    vim.keymap.set({ "n", "v" }, M.sub .. key, command, { desc = desc })
  end
  nmap("t", function()
    M.create_or_open_daily_note(0)
  end, "Daily note")
  nmap("y", function()
    M.create_or_open_daily_note(-1)
  end, "Yesterday note")
  nmap("r", function()
    M.create_or_open_daily_note(1)
  end, "Tomorrow note")
  nmap("n", function()
    M.find_or_create_note("note", 1, 1, 1)
  end, "Note Search / Create")
  nmap("d", function()
    M.find_or_create_note("daily", 1, 1)
  end, "Daily Search / Create")
  nmap("P", function()
    M.find_or_create_note("project", 0, 0)
  end, "Project Search / Create ")
  nmap("E", function()
    M.find_or_create_note("person", 0, 0)
  end, "Person Search / Create")
  nmap("C", function()
    M.find_or_create_note("company", 0, 0)
  end, "Company Search / Create")
  nmap("A", function()
    M.find_or_create_note("department", 0, 0)
  end, "Department Search / Create")
  nmap("e", function()
    M.find_element("person")
  end, "Open Person")
  nmap("p", function()
    M.find_element("project")
  end, "Open Project")
  nmap("a", function()
    M.find_element("department")
  end, "Open department")
end

return M
