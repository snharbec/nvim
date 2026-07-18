-- Colorscheme persistence
local state_file = vim.fn.stdpath("data") .. "/colorscheme-last"

-- Auto-save colorscheme name whenever it changes
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("colorscheme-persist", { clear = true }),
  callback = function(args)
    local f = io.open(state_file, "w")
    if f then
      f:write(args.match)
      f:close()
    end
  end,
})

-- Read the last saved colorscheme (if any)
local function read_saved_colorscheme()
  local f = io.open(state_file, "r")
  if not f then
    return nil
  end
  local name = f:read("*l")
  f:close()
  return name and vim.trim(name) ~= "" and vim.trim(name) or nil
end

-- Install colorscheme plugins
vim.pack.add({ 'https://github.com/catppuccin/nvim' })
vim.pack.add({ 'https://github.com/folke/tokyonight.nvim' })
vim.pack.add({ 'https://github.com/ellisonleao/gruvbox.nvim' })
vim.pack.add({ 'https://github.com/maxmx03/solarized.nvim' })
vim.pack.add({ 'https://github.com/sainnhe/everforest' })
vim.pack.add({ 'https://github.com/rebelot/kanagawa.nvim' })
vim.pack.add({ 'https://github.com/rose-pine/neovim' })
vim.pack.add({ 'https://github.com/EdenEast/nightfox.nvim' })
vim.pack.add({ 'https://github.com/numToStr/sakura.nvim' })

-- Load catppuccin (default fallback)
vim.cmd.packadd('nvim')
require("catppuccin").setup({
  flavour = "latte",
  transparent_background = false,
  show_end_of_buffer = false,
  term_colors = true,
})

-- Load other colorschemes so they're available via :colorscheme
vim.cmd.packadd('tokyonight.nvim')
pcall(function() require("tokyonight").setup({}) end)

vim.cmd.packadd('gruvbox.nvim')
pcall(function() require("gruvbox").setup({}) end)

vim.cmd.packadd('solarized.nvim')
pcall(function() require("solarized").setup({}) end)

vim.cmd.packadd('everforest')

vim.cmd.packadd('kanagawa.nvim')
pcall(function() require("kanagawa").setup({}) end)

vim.cmd.packadd('neovim')
pcall(function() require("rose-pine").setup({}) end)

vim.cmd.packadd('nightfox.nvim')
pcall(function() require("nightfox").setup({}) end)

vim.cmd.packadd('sakura.nvim')
pcall(function() require("sakura").setup({}) end)

-- Apply saved colorscheme or default to catppuccin
local saved = read_saved_colorscheme()
if saved then
  local ok = pcall(vim.cmd.colorscheme, saved)
  if not ok then
    vim.notify("Saved colorscheme '" .. saved .. "' not available, using catppuccin", vim.log.levels.WARN)
    vim.cmd.colorscheme("catppuccin")
  end
else
  vim.cmd.colorscheme("catppuccin")
end
