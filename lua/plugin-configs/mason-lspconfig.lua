local mason_lspconfig = fignvim.plug.load_module_file("mason-lspconfig")
if mason_lspconfig then
  mason_lspconfig.setup({
    -- Automatically install all servers setup via lsp-config
    automatic_installation = true,
  })
end
