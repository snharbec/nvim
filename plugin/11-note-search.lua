-- Custom note_search plugin (local)
-- Assuming note_search is in lua/note_search/ directory
-- This loads the custom plugin configuration
vim.pack.add({ 'https://github.com/snharbec/note_search.git' })

require("note_search").setup({
    notes_dir = vim.fn.expand(vim.env.NOTE_SEARCH_DIR or "~/.local/share/notes"),
    templates_dir = vim.fn.expand(vim.env.NOTE_SEARCH_DIR or "~/.local/share/notes") .. "/templates",
    find_command = "fd",
    keymap_group = "<leader>n",
    insert_group = "/",
})
