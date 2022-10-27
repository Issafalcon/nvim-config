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
local cmp_nvim_lsp = fignvim.plug.load_module_file("cmp_nvim_lsp")
if cmp_nvim_lsp then
  fignvim.lsp.capabilities = vim.tbl.deep_extend("force", fignvim.lsp.capabilities, cmp_nvim_lsp.default_capabilities())
end

function fignvim.lsp.capabilities.handle_document_highlighting(bufnr)
  local highlight_name = vim.fn.printf("lsp_document_highlight_%d", bufnr)
  vim.api.nvim_create_augroup(highlight_name, {})
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = highlight_name,
    buffer = bufnr,
    callback = function() vim.lsp.buf.document_highlight() end,
  })
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = highlight_name,
    buffer = bufnr,
    callback = function() vim.lsp.buf.clear_references() end,
  })
end

return fignvim.lsp.capabilities