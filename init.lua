-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
-- require("extra.daily").setup()



vim.api.nvim_set_hl(0, "MyInsertCursor", { fg = "white", bg = "red" })
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:block-MyInsertCursor-blinkon1,r-cr-o:hor20"
