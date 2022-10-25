fignvim.lsp = {}

--- ### fignvim LSP
--
-- This module is automatically loaded by fignvim on during it's initialization into global variable `astronvim.lsp`
--
-- This module can also be manually loaded with `local updater = require("core.utils").lsp`
--
-- @module core.utils.lsp
-- @see core.utils
-- @copyright 2022
-- @license GNU General Public License v3.0

fignvim.lsp = {}
local tbl_contains = vim.tbl_contains
local tbl_isempty = vim.tbl_isempty
local user_plugin_opts = fignvim.user_plugin_opts
local conditional_func = fignvim.conditional_func
local user_registration = user_plugin_opts("lsp.server_registration", nil, false)
local skip_setup = user_plugin_opts "lsp.skip_setup"


--- Helper function to set up a given server with the Neovim LSP client
-- @param server the name of the server to be setup
fignvim.lsp.setup = function(server)
  if not tbl_contains(skip_setup, server) then
    local opts = fignvim.lsp.server_settings(server)
    if type(user_registration) == "function" then
      user_registration(server, opts)
    else
      require("lspconfig")[server].setup(opts)
    end
  end
end

--- The `on_attach` function used by fignvim
-- @param client the LSP client details when attaching
-- @param bufnr the number of the buffer that the LSP client is attaching to
fignvim.lsp.on_attach = function(client, bufnr)

  fignvim.set_mappings(user_plugin_opts("lsp.mappings", lsp_mappings), { buffer = bufnr })
  if not vim.tbl_isempty(lsp_mappings.v) then
    fignvim.which_key_register({ v = { ["<leader>"] = { l = { name = "LSP" } } } }, { buffer = bufnr })
  end

  local on_attach_override = user_plugin_opts("lsp.on_attach", nil, false)
  local aerial_avail, aerial = pcall(require, "aerial")
  conditional_func(on_attach_override, true, client, bufnr)
  conditional_func(aerial.on_attach, aerial_avail, client, bufnr)
end

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
fignvim.lsp.capabilities = user_plugin_opts("lsp.capabilities", astronvim.lsp.capabilities)
fignvim.lsp.flags = user_plugin_opts "lsp.flags"

--- Get the server settings for a given language server to be provided to the server's `setup()` call
-- @param  server_name the name of the server
-- @return the table of LSP options used when setting up the given language server
function fignvim.lsp.server_settings(server_name)
  local server = require("lspconfig")[server_name]
  local opts = user_plugin_opts( -- get user server-settings
    "lsp.server-settings." .. server_name,
    user_plugin_opts("server-settings." .. server_name, { -- get default server-settings
      capabilities = vim.tbl_deep_extend("force", fignvim.lsp.capabilities, server.capabilities or {}),
      flags = vim.tbl_deep_extend("force", fignvim.lsp.flags, server.flags or {}),
    }, true, "configs")
  )
  local old_on_attach = server.on_attach
  local user_on_attach = opts.on_attach
  opts.on_attach = function(client, bufnr)
    conditional_func(old_on_attach, true, client, bufnr)
    fignvim.lsp.on_attach(client, bufnr)
    conditional_func(user_on_attach, true, client, bufnr)
  end
  return opts
end

return fignvim.lsp
