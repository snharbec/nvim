return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {},
  config = function()
    local flash = require("flash")
    flash.setup()

    -- Jump with 's' in normal mode
    vim.keymap.set("n", "s", function()
      flash.jump()
    end, { desc = "Flash jump" })
  end,
}
