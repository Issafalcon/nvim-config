local mason = fignvim.plug.load_module_file("mason")
if not mason then
  return
end

mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_uninstalled = "✗",
      package_pending = "⟳",
    },
  },
})
