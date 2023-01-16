fignvim.lsp = {}

require("lsp.mappings")
require("lsp.formatting")
require("lsp.null_ls")
require("lsp.handlers")

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
        runtime = true,
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
      lsp_overloads.setup(client, {
        ui = {
          close_events = { "CursorMoved", "CursorMovedI", "InsertCharPre" },
        },
      })
    end
  end
end

--- Get the server settings for a given language server to be provided to the server's `setup()` call
-- @param  server_name the name of the server
-- @return the table of LSP options used when setting up the given language server
function fignvim.lsp.server_settings(server_name)
  local fignvim_capabilities = require("lsp.capabilities")
  local server = require("lspconfig")[server_name]
  local server_config = fignvim.plug.load_module_file("lsp.lsp_servers." .. server_name)

  local server_on_attach = server.on_attach
  local custom_on_attach = server_config and server_config.on_attach

  local opts = {
    capabilities = vim.tbl_deep_extend("force", server.capabilities or {}, fignvim_capabilities),
    flags = server.flags or {},
    on_attach = function(client, bufnr)
      fignvim.fn.conditional_func(server_on_attach, server_on_attach ~= nil, client, bufnr)
      fignvim.lsp.on_attach(client, bufnr)
      fignvim.fn.conditional_func(custom_on_attach, custom_on_attach ~= nil, client, bufnr)
    end,
  }

  if server_config and server_config.opts then
    opts = vim.tbl_deep_extend("force", opts, server_config.opts)
  end

  return opts
end

function fignvim.lsp.setup_lsp_servers(server_list)
  local status_ok, _ = pcall(require, "lspconfig")
  if status_ok then
    fignvim.lsp.handlers.add_global_handlers()
    for _, server in ipairs(server_list) do
      fignvim.lsp.setup(server)
    end
  else
    return
  end
end

return fignvim.lsp
