local mason_registry = require("mason-registry")
local jdtls = require("jdtls")

-- 1. Finde den Pfad zur JDTLS Installation (via Mason)
local jdtls_path = "/home/har/.local/share/nvim/mason/jdtls_path"
local jdt_path = "/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home"
local path_to_launcher = vim.fn.glob(jdt_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
local path_to_config = vim.fn.glob(jdtls_path .. "/config_linux")

-- 2. Projekt-spezifisches Workspace-Verzeichnis
-- Das ist CRUCIAL für große Projekte. Jedes Projekt bekommt seinen eigenen Cache.
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

-- 3. Die Command-Zeile (Hier optimieren wir für große Projekte!)
local cmd = {
  "java",
  "-Declipse.application=org.eclipse.jdt.ls.ui.launcher",
  "-Dosgi.bundles.enable=true",
  -- "-data",
  -- workspace_dir,
  "-cp",
  path_to_launcher,
  "org.eclipse.jdt.ls.core.id1.launcher",

  -- PERFORMANCE-BOOST FÜR GROSSE PROJEKTE:
  -- Erhöhe den Heap-Speicher (Xmx). Wenn dein RAM es zulässt, setze hier 4G oder 8G.
  "-Xmx4G",
  "-Xms1G",
  "-XX:+UseG1GC", -- Moderner Garbage Collector für weniger Pausen
}

-- 4. LSP Konfiguration
local config = {
  cmd = cmd,
  root_dir = jdtls.setup.find_root({ ".git", "pom.xml", "build.gradle" }),
  settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      sources = {
        organizeImports = {
          starImport = true,
          staticStarImport = true,
        },
      },
      -- Hier kannst du weitere Java-spezifische Einstellungen vornehmen
    },
  },
  init_options = {
    bundles = {}, -- Hier könnten Erweiterungen für Spring Boot etc. rein
  },
}

-- 5. Startet den LSP
jdtls.start_or_attach(config)
