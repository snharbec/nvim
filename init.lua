-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
-- require("extra.daily").setup()

require("note-type").setup()

-- I have to set this here because otherwise it is override by the colorscheme
-- Cursor Color in insert mode
-- guibg sets the cursor color; guifg sets the text color under the cursor
vim.api.nvim_set_hl(0, "MyInsertCursor", { fg = "white", bg = "red" })
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:block-MyInsertCursor-blinkon1,r-cr-o:hor20"
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  command = "setlocal completefunc= | setlocal omnifunc=",
})
