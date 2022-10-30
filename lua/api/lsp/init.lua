fignvim.lsp = {}

require("api.lsp.capabilities")
require("api.lsp.mappings")
require("api.lsp.formatting")
require("api.lsp.null_ls")
require("api.lsp.handlers")

--- Helper function to set up a given server with the Neovim LSP client
-- @param server the name of the server to be setup
fignvim.lsp.setup = function(server)
  local opts = fignvim.lsp.server_settings(server)

  if server == "sumneko_lua" and fignvim.plug.is_available("neodev.nvim") then
    local neodev = fignvim.plug.load_module_file("neodev")
    -- For developing Lua plugins for Neovim Only
    -- Comment out below lines so lua_dev is not used when working on other Lua projects
    neodev.setup({
      library = {
        enabled = false,
        types = true,
        -- you can also specify the list of plugins to make available as a workspace library
        -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
        plugins = false,
        runtime = false,
      },
      setup_jsonls = true,
    })
  end

  require("lspconfig")[server].setup(opts)
end

--- The `on_attach` function used by fignvim
-- @param client the LSP client details when attaching
-- @param bufnr the number of the buffer that the LSP client is attaching to
function fignvim.lsp.on_attach(client, bufnr)
  local capabilities = client.server_capabilities

  fignvim.lsp.mappings.set_buf_mappings(capabilities, client.name, bufnr)

  if capabilities.documentFormattingProvider then
    fignvim.lsp.formatting.create_buf_autocmds(bufnr)
  end

  if capabilities.documentHighlightProvider then
    fignvim.lsp.handlers.handle_document_highlighting(bufnr)
  end

  if client.server_capabilities.signatureHelpProvider then
    local lsp_overloads = fignvim.plug.load_module_file("lsp-overloads")
    if lsp_overloads then
      lsp_overloads.setup(client, {})
    end
  end

  local aerial = fignvim.plug.load_module_file("aerial")
  if aerial then
    aerial.on_attach(client, bufnr)
  end
end

--- Get the server settings for a given language server to be provided to the server's `setup()` call
-- @param  server_name the name of the server
-- @return the table of LSP options used when setting up the given language server
function fignvim.lsp.server_settings(server_name)
  local server = require("lspconfig")[server_name]
  local server_config = fignvim.config.get_lsp_server_config(server_name)

  local server_on_attach = server.on_attach
  local custom_on_attach = server_config and server_config.on_attach

  local opts = {
    capabilities = vim.tbl_deep_extend("force", fignvim.lsp.capabilities, server.capabilities or {}),
    flags = server.flags or {},
    on_attach = function(client, bufnr)
      fignvim.fn.conditional_func(server_on_attach, server_on_attach ~= nil, client, bufnr)
      fignvim.lsp.on_attach(client, bufnr)
      fignvim.fn.conditional_func(custom_on_attach, custom_on_attach ~= nil, client, bufnr)
    end,
  }

  if server_config and server_config.opts then
    vim.tbl_deep_extend("force", opts, server_config.opts)
  end

  return opts
end

function fignvim.lsp.setup_all_lsp_servers()
  fignvim.lsp.handlers.add_global_handlers()
  local server_list = require("user-configs.lsp").servers
  for _, server in ipairs(server_list) do
    fignvim.lsp.setup(server)
  end
end

return fignvim.lsp
