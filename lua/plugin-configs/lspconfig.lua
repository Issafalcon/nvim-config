local lspconfig = fignvim.plug.load_module_file("lspconfig")
if not lspconfig then
  fignvim.ui.notify("LSPConfig not found", "warn")
  return
end

fignvim.lsp.setup_all_lsp_servers()
