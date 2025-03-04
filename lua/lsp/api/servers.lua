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

  if server == "lua_ls" then
    local neodev_ok, neodev = pcall(require, "neodev")

    -- For developing Lua plugins for Neovim Only
    -- Comment out below lines so lua_dev is not used when working on other Lua projects
    -- Some
    if neodev_ok then
      neodev.setup({
        library = {
          enabled = true,
          types = true,
          -- you can also specify the list of plugins to make available as a workspace library
          -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
          plugins = true,
          runtime = true,
        },
        setup_jsonls = true,
        lspconfig = true,
        pathStrict = true,
      })
    end
  end

  require("lspconfig")[server].setup(opts)
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
      if server == "roslyn.nvim" then
        require("roslyn").setup({
          config = {
            on_attach = fignvim.lsp.servers.on_attach,
            capabilities = capabilities,
            settings = {
              ["csharp|inlay_hints"] = {
                ["csharp_enable_inlay_hints_for_implicit_object_creation"] = true,
                ["csharp_enable_inlay_hints_for_implicit_variable_types"] = true,
                ["csharp_enable_inlay_hints_for_lambda_parameter_types"] = true,
                ["csharp_enable_inlay_hints_for_types"] = true,
                ["dotnet_enable_inlay_hints_for_indexer_parameters"] = true,
                ["dotnet_enable_inlay_hints_for_literal_parameters"] = true,
                ["dotnet_enable_inlay_hints_for_object_creation_parameters"] = true,
                ["dotnet_enable_inlay_hints_for_other_parameters"] = true,
                ["dotnet_enable_inlay_hints_for_parameters"] = true,
                ["dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix"] = true,
                ["dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name"] = true,
                ["dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent"] = true,
              },
            },
          },
        })
      else
        fignvim.lsp.servers.setup(server, capabilities)
      end
    end
  else
    return
  end
end

return fignvim.lsp.servers
