return {
  {
    "nvim-mini/mini.nvim",
    version = false,
    event = "VeryLazy",
    config = function()
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

      -- mini.cursorword - highlight word under cursor
      require("mini.cursorword").setup({
        delay = 2000,
      })

      -- mini.clue - which-key replacement
      local miniclue = require('mini.clue')
      miniclue.setup({
        triggers = {
          -- Leader triggers
          { mode = 'n', keys = '<Leader>' },
          { mode = 'x', keys = '<Leader>' },
          -- Built-in completion
          { mode = 'i', keys = '<C-x>' },
          -- `g` key
          { mode = 'n', keys = 'g' },
          { mode = 'x', keys = 'g' },
          -- Marks
          { mode = 'n', keys = "'" },
          { mode = 'n', keys = '`' },
          { mode = 'x', keys = "'" },
          { mode = 'x', keys = '`' },
          -- Registers
          { mode = 'n', keys = '"' },
          { mode = 'x', keys = '"' },
          { mode = 'i', keys = '<C-r>' },
          { mode = 'c', keys = '<C-r>' },
          -- Window commands
          { mode = 'n', keys = '<C-w>' },
          -- `z` key
          { mode = 'n', keys = 'z' },
          { mode = 'x', keys = 'z' },
        },

        clues = {
          -- Enhance this by adding descriptions for <Leader> mapping groups
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
          -- Custom clues for leader groups
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
          config = {
            width = 'auto',
            border = 'none',
          },
          delay = 500,
        },
      })

      -- Session management
      local sessions = require("mini.sessions")
      local session_dir = vim.fn.stdpath("data") .. "/sessions"
      
      -- Ensure session directory exists
      vim.fn.mkdir(session_dir, "p")
      
      sessions.setup({
        autowrite = true,
        directory = session_dir,
        force = { read = false, write = true, delete = false },
        hooks = {
          pre = { read = nil, write = nil, delete = nil },
          post = { read = nil, write = nil, delete = nil },
        },
      })

      -- Helper to get session name from current directory
      local function get_session_name()
        local cwd = vim.fn.getcwd()
        -- Replace path separators and special chars with underscores
        local name = cwd:gsub("[/\\]", "_")
                         :gsub(":", "_")
                         :gsub("%.", "_")
        return name
      end

      -- Check if session exists on startup and prompt user
      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("session-auto-restore", { clear = true }),
        callback = function()
          -- Skip if no file arguments were provided and we're just opening nvim
          if vim.fn.argc() > 0 then
            return
          end
          
          local session_name = get_session_name()
          local session_file = session_dir .. "/" .. session_name .. ".vim"
          
          -- Check if session file exists
          if vim.fn.filereadable(session_file) == 1 then
            -- Ask user if they want to restore the session
            vim.schedule(function()
              local choice = vim.fn.confirm(
                "Restore session for " .. vim.fn.getcwd() .. "?",
                "&Yes\n&No",
                1
              )
              if choice == 1 then
                sessions.read(session_name)
              end
            end)
          end
        end,
      })

      -- Auto-save session on exit
      vim.api.nvim_create_autocmd("VimLeavePre", {
        group = vim.api.nvim_create_augroup("session-auto-save", { clear = true }),
        callback = function()
          local session_name = get_session_name()
          sessions.write(session_name)
        end,
      })

      -- Manual session commands
      vim.api.nvim_create_user_command("SessionSave", function()
        local session_name = get_session_name()
        sessions.write(session_name)
        vim.notify("Session saved: " .. session_name, vim.log.levels.INFO)
      end, { desc = "Save current session" })

      vim.api.nvim_create_user_command("SessionLoad", function()
        local session_name = get_session_name()
        if sessions.detected[session_name] then
          sessions.read(session_name)
          vim.notify("Session loaded: " .. session_name, vim.log.levels.INFO)
        else
          vim.notify("No session found for: " .. session_name, vim.log.levels.WARN)
        end
      end, { desc = "Load session for current directory" })

      vim.api.nvim_create_user_command("SessionDelete", function()
        local session_name = get_session_name()
        sessions.delete(session_name)
        vim.notify("Session deleted: " .. session_name, vim.log.levels.INFO)
      end, { desc = "Delete session for current directory" })

      vim.api.nvim_create_user_command("SessionList", function()
        local detected = sessions.detected
        if vim.tbl_isempty(detected) then
          vim.notify("No sessions found", vim.log.levels.INFO)
          return
        end
        local names = {}
        for name, _ in pairs(detected) do
          table.insert(names, name)
        end
        table.sort(names)
        print("Available sessions:")
        for _, name in ipairs(names) do
          print("  - " .. name)
        end
      end, { desc = "List all sessions" })

      -- Keymaps
      vim.keymap.set("n", "<leader>Ss", "<cmd>SessionSave<cr>", { desc = "Save session" })
      vim.keymap.set("n", "<leader>Sl", "<cmd>SessionLoad<cr>", { desc = "Load session" })
      vim.keymap.set("n", "<leader>Sd", "<cmd>SessionDelete<cr>", { desc = "Delete session" })
      vim.keymap.set("n", "<leader>SL", "<cmd>SessionList<cr>", { desc = "List sessions" })
    end,
  },
}
