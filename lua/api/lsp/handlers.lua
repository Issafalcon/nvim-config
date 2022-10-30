fignvim.lsp.handlers = {}

function fignvim.lsp.handlers.handle_document_highlighting(bufnr)
  local highlight_name = vim.fn.printf("lsp_document_highlight_%d", bufnr)
  vim.api.nvim_create_augroup(highlight_name, {})
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = highlight_name,
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.document_highlight()
    end,
  })
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = highlight_name,
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.clear_references()
    end,
  })
end

function fignvim.lsp.handlers.add_global_handlers()
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
end

return fignvim.lsp.handlers
