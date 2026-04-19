vim.pack.add({ 'https://github.com/mfussenegger/nvim-jdtls' })

-- JDTLS configuration for Java
local config = {
  cmd = { 'jdtls' },
  root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
}

-- Attach JDTLS only for Java files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    require('jdtls').start_or_attach(config)
  end,
})
