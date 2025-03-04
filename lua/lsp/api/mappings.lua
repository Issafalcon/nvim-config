---@diagnostic disable: missing-parameter
fignvim.lsp.mappings = {}

fignvim.lsp.mappings.on_attach = function(client, bufnr)
  local capabilities = client.server_capabilities
  local client_name = client.name
  fignvim.lsp.mappings.set_buf_mappings(capabilities, client_name, bufnr, false)
end

--- Sets buffer mappings for the given client, if the client supports them.
---@param capabilities table The current server capabilities for the language server
---@param client_name string Name of the current language server client
---@param bufnr number the buffer number to set mappings for
---@param force_mappings boolean Whether to force the mappings to be set, regardless of client capabilities
function fignvim.lsp.mappings.set_buf_mappings(capabilities, client_name, bufnr, force_mappings)
  local keymaps = require("keymaps").Lsp
  local lsp_keymaps = {}
  -- Insert keymaps into lsp_keymaps with the 4th item in the keymap table merged with { buffer = bufnr }

  table.insert(lsp_keymaps, keymaps.DiagnosticsNext)
  table.insert(lsp_keymaps, keymaps.DiagnosticsPrev)
  table.insert(lsp_keymaps, keymaps.ListDocumentSymbols)
  table.insert(lsp_keymaps, keymaps.ListWorkspaceSymbols)
  table.insert(lsp_keymaps, keymaps.ToggleInlayHints)

  if capabilities.codeActionProvider or force_mappings then
    table.insert(lsp_keymaps, keymaps.CodeActions)
  end

  if capabilities.declarationProvider or force_mappings then
    table.insert(lsp_keymaps, keymaps.GotoDeclaration)
  end

  if capabilities.definitionProvider or capabilities.typeDefinitionProvider or force_mappings then
    table.insert(lsp_keymaps, keymaps.GotoDefinition)
  end

  if capabilities.documentFormattingProvider or force_mappings then
    table.insert(lsp_keymaps, keymaps.Format)
    table.insert(lsp_keymaps, keymaps.ToggleAutoFormatOnSave)
  end

  if capabilities.hoverProvider or force_mappings then
    table.insert(lsp_keymaps, keymaps.HoverDocumentation)
  end

  if capabilities.implementationProvider or force_mappings then
    table.insert(lsp_keymaps, keymaps.GotoTelescopeImplementations)
  end

  if capabilities.referencesProvider or force_mappings then
    table.insert(lsp_keymaps, keymaps.GotoTelescopeReferences)
  end

  if capabilities.renameProvider or force_mappings then
    table.insert(lsp_keymaps, keymaps.RenameSymbol)
  end

  if capabilities.signatureHelpProvider or force_mappings then
    table.insert(lsp_keymaps, keymaps.ShowSignatureHelp)
  end

  if client_name == "ts_ls" then
    table.insert(lsp_keymaps, keymaps.TypeScriptOrganizeImports)
    table.insert(lsp_keymaps, keymaps.TypeScriptRenameFile)
    table.insert(lsp_keymaps, keymaps.TypescriptImportAll)
  end

  fignvim.mappings.create_buf_local_keymaps(lsp_keymaps, bufnr)
end

return fignvim.lsp.mappings
