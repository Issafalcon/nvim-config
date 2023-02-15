fignvim.lsp = {}

require("lsp.mappings")
require("lsp.formatting")
require("lsp.null_ls")
require("lsp.handlers")

--- Helper function to set up a given server with the Neovim LSP client
-- @param server the name of the server to be setup
fignvim.lsp.setup = function(server)
  local opts = fignvim.lsp.server_settings(server)

  if server == "lua_ls" then
    local neodev_ok, neodev = pcall(require, "neodev")
    -- For developing Lua plugins for Neovim Only
    -- Comment out below lines so lua_dev is not used when working on other Lua projects
    if neodev_ok then
      neodev.setup({
        library = {
          enabled = vim.g.plugin_dev,
          types = true,
          -- you can also specify the list of plugins to make available as a workspace library
          -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
          plugins = vim.g.plugin_dev,
          runtime = true,
        },
        setup_jsonls = true,
      })
    end
  end

  require("lspconfig")[server].setup(opts)
end

--- The `on_attach` function used by fignvim
-- @param client the LSP client details when attaching
-- @param bufnr the number of the buffer that the LSP client is attaching to
function fignvim.lsp.on_attach(client, bufnr)
  local capabilities = client.server_capabilities

  fignvim.lsp.mappings.set_buf_mappings(capabilities, client.name, bufnr)

  if capabilities.documentFormattingProvider then fignvim.lsp.formatting.create_buf_autocmds(bufnr) end

  if capabilities.documentHighlightProvider then fignvim.lsp.handlers.handle_document_highlighting(bufnr) end

  if client.server_capabilities.signatureHelpProvider then
    local lsp_overloads_ok, lsp_overloads = pcall(require, "lsp-overloads")
    if lsp_overloads_ok then
      lsp_overloads.setup(client, {
        ui = {
          close_events = { "CursorMoved", "CursorMovedI", "InsertCharPre" },
          floating_window_above_cur_line = true,
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
  local _, server_config = pcall(require, "lsp.lsp_servers." .. server_name)

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

  if server_config and server_config.opts then opts = vim.tbl_deep_extend("force", opts, server_config.opts) end

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
