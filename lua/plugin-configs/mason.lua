local mason = fignvim.plug.load_module_file("mason")
if not mason then
  return
end

mason.setup({
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
