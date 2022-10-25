fignvim.lsp.mappings = {}

--- Sets buffer mappings for the given client, if the client supports them.
---@param client table the client to set mappings for
---@param bufnr number the buffer number to set mappings for
function fignvim.lsp.mappings.set_buf_mappings(client, bufnr)
  local capabilities = client.server_capabilities
  fignvim.config.map_buf(bufnr,)
  local lsp_mappings = {
    n = {
      ["<leader>ld"] = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" },
      ["[d"] = { function() vim.diagnostic.goto_prev() end, desc = "Previous diagnostic" },
      ["]d"] = { function() vim.diagnostic.goto_next() end, desc = "Next diagnostic" },
      ["gl"] = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" },
    },
    v = {},
  }

  if capabilities.codeActionProvider then
    lsp_mappings.n["<leader>la"] = { function() vim.lsp.buf.code_action() end, desc = "LSP code action" }
    lsp_mappings.v["<leader>la"] = lsp_mappings.n["<leader>la"]
  end

  if capabilities.declarationProvider then
    lsp_mappings.n["gD"] = { function() vim.lsp.buf.declaration() end, desc = "Declaration of current symbol" }
  end

  if capabilities.definitionProvider then
    lsp_mappings.n["gd"] = { function() vim.lsp.buf.definition() end, desc = "Show the definition of current symbol" }
  end

  if capabilities.documentFormattingProvider then
    lsp_mappings.n["<leader>lf"] = {
      function() vim.lsp.buf.format(fignvim.lsp.format_opts) end,
      desc = "Format code",
    }
    lsp_mappings.v["<leader>lf"] = lsp_mappings.n["<leader>lf"]
      lsp_mappings.n["<leader>uf"] = {
        function() fignvim.ui.toggle_autoformat() end,
        desc = "Toggle autoformatting",
      }
  end

  if capabilities.documentHighlightProvider then
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

  if capabilities.hoverProvider then
    lsp_mappings.n["K"] = { function() vim.lsp.buf.hover() end, desc = "Hover symbol details" }
  end

  if capabilities.implementationProvider then
    lsp_mappings.n["gI"] = { function() vim.lsp.buf.implementation() end, desc = "Implementation of current symbol" }
  end

  if capabilities.referencesProvider then
    lsp_mappings.n["gr"] = { function() vim.lsp.buf.references() end, desc = "References of current symbol" }
  end

  if capabilities.renameProvider then
    lsp_mappings.n["<leader>lr"] = { function() vim.lsp.buf.rename() end, desc = "Rename current symbol" }
  end

  if capabilities.signatureHelpProvider then
    lsp_mappings.n["<leader>lh"] = { function() vim.lsp.buf.signature_help() end, desc = "Signature help" }
  end

  if capabilities.typeDefinitionProvider then
    lsp_mappings.n["gT"] = { function() vim.lsp.buf.type_definition() end, desc = "Definition of current type" }
  end
end
return fignvim.lsp.mappings
