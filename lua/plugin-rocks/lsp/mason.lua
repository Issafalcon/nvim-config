require("mason").setup({
  providers = {
    "mason.providers.registry-api",
    "mason.providers.client",
  },
  ui = {
    icons = {
      package_installed = "✓",
      package_uninstalled = "✗",
      package_pending = "⟳",
    },
  },
})
