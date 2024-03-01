fignvim.lsp = {}

require("lsp.mappings")
require("lsp.formatting")
require("lsp.none_ls")
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

--- The `on_attach` function used by fignvim
-- @param client the LSP client details when attaching
-- @param bufnr the number of the buffer that the LSP client is attaching to
function fignvim.lsp.on_attach(client, bufnr)
  local capabilities = client.server_capabilities

  fignvim.lsp.mappings.set_buf_mappings(capabilities, client.name, bufnr)

  if capabilities.documentFormattingProvider or client.name == "eslint" then
    fignvim.lsp.formatting.create_buf_autocmds(bufnr, client.name)
  end

  if capabilities.documentHighlightProvider then fignvim.lsp.handlers.handle_document_highlighting(bufnr) end

  if client.server_capabilities.signatureHelpProvider then
    local lsp_overloads_ok, lsp_overloads = pcall(require, "lsp-overloads")
    if lsp_overloads_ok then
      lsp_overloads.setup(client, {
        ui = {
          close_events = { "CursorMoved", "CursorMovedI", "InsertCharPre" },
          floating_window_above_cur_line = true,
          silent = true,
        },
      })
    end
  end

  -- Workaround for semantic token issue with omnisharp-roslyn
  -- See https://github.com/OmniSharp/omnisharp-roslyn/issues/2483
  if client.name == "omnisharp" then
    client.server_capabilities.semanticTokensProvider = {
      full = vim.empty_dict(),
      legend = {
        tokenModifiers = { "static_symbol" },
        tokenTypes = {
          "comment",
          "excluded_code",
          "identifier",
          "keyword",
          "keyword_control",
          "number",
          "operator",
          "operator_overloaded",
          "preprocessor_keyword",
          "string",
          "whitespace",
          "text",
          "static_symbol",
          "preprocessor_text",
          "punctuation",
          "string_verbatim",
          "string_escape_character",
          "class_name",
          "delegate_name",
          "enum_name",
          "interface_name",
          "module_name",
          "struct_name",
          "type_parameter_name",
          "field_name",
          "enum_member_name",
          "constant_name",
          "local_name",
          "parameter_name",
          "method_name",
          "extension_method_name",
          "property_name",
          "event_name",
          "namespace_name",
          "label_name",
          "xml_doc_comment_attribute_name",
          "xml_doc_comment_attribute_quotes",
          "xml_doc_comment_attribute_value",
          "xml_doc_comment_cdata_section",
          "xml_doc_comment_comment",
          "xml_doc_comment_delimiter",
          "xml_doc_comment_entity_reference",
          "xml_doc_comment_name",
          "xml_doc_comment_processing_instruction",
          "xml_doc_comment_text",
          "xml_literal_attribute_name",
          "xml_literal_attribute_quotes",
          "xml_literal_attribute_value",
          "xml_literal_cdata_section",
          "xml_literal_comment",
          "xml_literal_delimiter",
          "xml_literal_embedded_expression",
          "xml_literal_entity_reference",
          "xml_literal_name",
          "xml_literal_processing_instruction",
          "xml_literal_text",
          "regex_comment",
          "regex_character_class",
          "regex_anchor",
          "regex_quantifier",
          "regex_grouping",
          "regex_alternation",
          "regex_text",
          "regex_self_escaped_character",
          "regex_other_escape",
        },
      },
      range = true,
    }
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
      if server == "roslyn.nvim" then
        require("roslyn").setup({
          on_attach = fignvim.lsp.on_attach,
          capabilities = fignvim.lsp.capabilities,
        })
      else
        fignvim.lsp.setup(server)
      end
    end
  else
    return
  end
end

return fignvim.lsp
