fignvim.lsp.mappings = {}

--- Sets buffer mappings for the given client, if the client supports them.
---@param capabilities table The current server capabilities for the language server
---@param client_name string Name of the current language server client
---@param bufnr number the buffer number to set mappings for
function fignvim.lsp.mappings.set_buf_mappings(capabilities, client_name, bufnr)
  local lsp_mappings = require("user-configs.mappings").lsp_mappings

  fignvim.config.create_mapping(lsp_mappings.LSP.prev_diagnostic, bufnr)
  fignvim.config.create_mapping(lsp_mappings.LSP.next_diagnostic, bufnr)
  fignvim.config.create_mapping(lsp_mappings.LSP.hover_diagnostic, bufnr)

  if fignvim.plug.is_available("telescope.nvim") then
    fignvim.config.create_mapping(lsp_mappings.LSP.document_symbols_telescope, bufnr)
    fignvim.config.create_mapping(lsp_mappings.LSP.workspace_symbols_telescope, bufnr)
  end

  if capabilities.codeActionProvider then
    if fignvim.plug.is_available("lspsaga") then
      fignvim.config.create_mapping(lsp_mappings.LSP.code_action_saga, bufnr)
    else
      fignvim.config.create_mapping(lsp_mappings.LSP.code_action, bufnr)
    end
  end

  if capabilities.declarationProvider then
    fignvim.config.create_mapping(lsp_mappings.LSP.goto_declaration, bufnr)
  end

  if capabilities.definitionProvider then
    fignvim.config.create_mapping(lsp_mappings.LSP.goto_definition, bufnr)
  end

  if capabilities.documentFormattingProvider then
    fignvim.config.create_mapping(lsp_mappings.LSP.format_code, bufnr)
    fignvim.config.create_mapping(lsp_mappings.LSP.toggle_autoformat, bufnr)
  end

  if capabilities.hoverProvider then
    if fignvim.plug.is_available("lspsaga") then
      fignvim.config.create_mapping(lsp_mappings.LSP.hover_doc_saga, bufnr)
    else
      fignvim.config.create_mapping(lsp_mappings.LSP.hover_doc, bufnr)
    end
  end

  if capabilities.implementationProvider then
    if fignvim.plug.is_available("telescope.nvim") then
      fignvim.config.create_mapping(lsp_mappings.LSP.goto_implementation_telescope, bufnr)
    else
      fignvim.config.create_mapping(lsp_mappings.LSP.goto_implementation, bufnr)
    end
  end

  if capabilities.referencesProvider then
    if fignvim.plug.is_available("telescope.nvim") then
      fignvim.config.create_mapping(lsp_mappings.LSP.goto_references_telescope, bufnr)
    else
      fignvim.config.create_mapping(lsp_mappings.LSP.goto_references, bufnr)
    end
  end

  if capabilities.renameProvider then
    fignvim.config.create_mapping(lsp_mappings.LSP.rename_symbol, bufnr)
  end

  if capabilities.signatureHelpProvider then
    fignvim.config.create_mapping(lsp_mappings.LSP.signature_overloads, bufnr)
    fignvim.config.create_mapping(lsp_mappings.LSP.signature_help, bufnr)
  end

  if capabilities.typeDefinitionProvider then
    fignvim.config.create_mapping(lsp_mappings.LSP.goto_definition, bufnr)
  end

  if client_name == "tsserver" then
    fignvim.config.create_mapping(lsp_mappings.LSP.tsserver_organize, bufnr)
    fignvim.config.create_mapping(lsp_mappings.LSP.tsserver_rename_file, bufnr)
    fignvim.config.create_mapping(lsp_mappings.LSP.tsserver_import_all, bufnr)
  end
end

return fignvim.lsp.mappings
