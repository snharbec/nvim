return {
  "snharbec/note_search",
  lazy = false,
  ft = "markdown",
  dependencies = {
    "folke/snacks.nvim",
  },
  opts = {
    notes_dir = vim.fn.expand(vim.env.NOTE_SEARCH_DIR or "~/.local/share/notes"),
    templates_dir = vim.fn.expand(vim.env.NOTE_SEARCH_DIR or "~/.local/share/notes") .. "/templates",
    find_command = "fd",
    keymap_group = "<leader>n",
    insert_group = "/",
  },
}
