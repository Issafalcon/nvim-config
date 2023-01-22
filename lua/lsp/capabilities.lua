fignvim.lsp.capabilities = {}

--- The default fignvim LSP capabilities
fignvim.lsp.capabilities = vim.lsp.protocol.make_client_capabilities()
fignvim.lsp.capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
fignvim.lsp.capabilities.textDocument.completion.completionItem.snippetSupport = true
fignvim.lsp.capabilities.textDocument.completion.completionItem.preselectSupport = true
fignvim.lsp.capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
fignvim.lsp.capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
fignvim.lsp.capabilities.textDocument.completion.completionItem.deprecatedSupport = true
fignvim.lsp.capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
fignvim.lsp.capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
fignvim.lsp.capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" },
}

-- Add capabilities required for LSP based completions
  local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if status_ok then
    fignvim.lsp.capabilities = vim.tbl_deep_extend("force", fignvim.lsp.capabilities, cmp_nvim_lsp.default_capabilities())
  end

return fignvim.lsp.capabilities
