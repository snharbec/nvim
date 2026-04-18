return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },
  cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
  build = ":MasonUpdate",
  config = function()
    require("mason").setup({
      ui = {
        check_outdated_packages_on_open = true,
        border = "none",
        width = 0.8,
        height = 0.8,
        icons = {
          package_installed = "◍",
          package_pending = "◍",
          package_uninstalled = "◍",
        },
      },
    })

    -- Mason-lspconfig bridges mason.nvim with nvim-lspconfig
    require("mason-lspconfig").setup({
      automatic_installation = false,
    })
  end,
}
