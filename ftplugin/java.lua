local mason_registry = require("mason-registry")
local jdtls = require("jdtls")

-- 1. JDTLS paths via Mason
local jdtls_path = "/Users/har/.local/share/nvim/mason/packages/jdtls"
local path_to_launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar", true)

-- Use macOS config since we're on macOS (darwin)
local path_to_config = jdtls_path .. "/config_mac"

-- Check for ARM64 Mac and use appropriate config
if vim.fn.has("mac") == 1 and vim.fn.system("uname -m"):match("arm64") then
  path_to_config = jdtls_path .. "/config_mac_arm"
end

-- 2. Project-specific workspace directory
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

-- Ensure workspace directory exists
vim.fn.mkdir(workspace_dir, "p")

-- 3. Java command with JDTLS launcher
local cmd = {
  "java",
  "-Declipse.application=org.eclipse.jdt.ls.core.id1",
  "-Dosgi.bundles.defaultStartLevel=4",
  "-Declipse.product=org.eclipse.jdt.ls.core.product",
  "-Dlog.protocol=true",
  "-Dlog.level=ALL",
  "-Xmx4G",
  "-Xms1G",
  "-XX:+UseG1GC",
  "-XX:+UseStringDeduplication",
  "--add-modules=ALL-SYSTEM",
  "--add-opens", "java.base/java.util=ALL-UNNAMED",
  "--add-opens", "java.base/java.lang=ALL-UNNAMED",
  "-jar", path_to_launcher,
  "-configuration", path_to_config,
  "-data", workspace_dir,
}

-- 4. LSP Configuration
local config = {
  cmd = cmd,
  root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
  settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}",
        },
        useBlocks = true,
      },
    },
  },
  init_options = {
    bundles = {},
  },
  on_attach = function(client, bufnr)
    -- Enable formatting
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
    end
    
    -- JDTLS specific keymaps
    local opts = { buffer = bufnr, silent = true }
    vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, { desc = "Organize Imports", buffer = bufnr })
    vim.keymap.set("n", "<leader>jv", jdtls.extract_variable, { desc = "Extract Variable", buffer = bufnr })
    vim.keymap.set("v", "<leader>jv", function() jdtls.extract_variable(true) end, { desc = "Extract Variable", buffer = bufnr })
    vim.keymap.set("n", "<leader>jc", jdtls.extract_constant, { desc = "Extract Constant", buffer = bufnr })
    vim.keymap.set("v", "<leader>jc", function() jdtls.extract_constant(true) end, { desc = "Extract Constant", buffer = bufnr })
    vim.keymap.set("v", "<leader>jm", function() jdtls.extract_method(true) end, { desc = "Extract Method", buffer = bufnr })
  end,
}

-- 5. Start JDTLS
jdtls.start_or_attach(config)
