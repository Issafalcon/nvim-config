fignvim.lsp.servers = {}

--- Helper function to set up a given server with the Neovim LSP client
-- @param server the name of the server to be setup
function fignvim.lsp.servers.setup(server, capabilities)
  local default_server_config = require("lspconfig")[server]
  local custom_server_config = fignvim.lsp.servers.server_settings(server)

  local server_on_attach = default_server_config.on_attach
  local custom_on_attach = custom_server_config.on_attach

  local opts = {
    capabilities = vim.tbl_deep_extend("force", default_server_config.capabilities or {}, capabilities),
    flags = default_server_config.flags or {},
    on_attach = function(client, bufnr)
      fignvim.fn.conditional_func(server_on_attach, server_on_attach ~= nil, client, bufnr)
      fignvim.fn.conditional_func(custom_on_attach, custom_on_attach ~= nil, client, bufnr)
    end,
  }

  if custom_server_config and custom_server_config.opts then
    opts = vim.tbl_deep_extend("force", opts, custom_server_config.opts)
  end

  fignvim.lsp.on_attach(opts.on_attach, server)

  if server ~= "roslyn" then
    vim.lsp.enable(server)
  end

  vim.lsp.config(server, opts)
end

--- Get the server settings for a given language server to be provided to the server's `setup()` call
-- @param  server_name the name of the server
-- @return the table of LSP options used when setting up the given language server
function fignvim.lsp.servers.server_settings(server_name)
  local _, server_config = pcall(require, "lsp.lsp_servers." .. server_name)

  return server_config
end

function fignvim.lsp.servers.setup_lsp_servers(server_list, capabilities)
  local status_ok, _ = pcall(require, "lspconfig")
  if status_ok then
    for _, server in ipairs(server_list) do
      fignvim.lsp.servers.setup(server, capabilities)
    end
  else
    return
  end
end

return fignvim.lsp.servers
