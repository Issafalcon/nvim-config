fignvim.lsp = {}

---@type table<string, table<vim.lsp.Client, table<number, boolean>>>
fignvim.lsp.supports_method = {}

require("lsp.api.servers")
require("lsp.api.capabilities")
require("lsp.api.formatting")
require("lsp.api.mappings")
require("lsp.api.handlers")
require("lsp.api.code-action")

---@param on_attach fun(client:vim.lsp.Client, buffer)
---@param name? string
function fignvim.lsp.on_attach(on_attach, name)
  return vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf ---@type number
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and (not name or client.name == name) then
        return on_attach(client, buffer)
      end
    end,
  })
end

---@param method string
---@param fn fun(client:vim.lsp.Client, buffer)
function fignvim.lsp.on_supports_method(method, fn)
  fignvim.lsp.supports_method[method] = fignvim.lsp.supports_method[method] or setmetatable({}, { __mode = "k" })
  return vim.api.nvim_create_autocmd("User", {
    pattern = "LspSupportsMethod",
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local buffer = args.data.buffer ---@type number
      if client and method == args.data.method then
        return fn(client, buffer)
      end
    end,
  })
end
---@param client vim.lsp.Client
function fignvim.lsp.check_methods(client, buffer)
  -- don't trigger on invalid buffers
  if not vim.api.nvim_buf_is_valid(buffer) then
    return
  end
  -- don't trigger on non-listed buffers
  if not vim.bo[buffer].buflisted then
    return
  end
  -- don't trigger on nofile buffers
  if vim.bo[buffer].buftype == "nofile" then
    return
  end
  for method, clients in pairs(fignvim.lsp.supports_method) do
    clients[client] = clients[client] or {}
    if not clients[client][buffer] then
      if client.supports_method and client.supports_method(method, { bufnr = buffer }) then
        clients[client][buffer] = true
        vim.api.nvim_exec_autocmds("User", {
          pattern = "LspSupportsMethod",
          data = { client_id = client.id, buffer = buffer, method = method },
        })
      end
    end
  end
end

---Setup LSP
---@param opts PluginLspOpts
function fignvim.lsp.setup(opts)
  local client_capabilities = fignvim.lsp.capabilities.create_capabilities(opts)

  -- 1. Register our LSP formatter
  fignvim.formatting.register(fignvim.lsp.formatting.get_formatter())

  -- 2. Setup standard and dynamic LSP capbilities
  fignvim.lsp.capabilities.setup_capability_registration_handler()
  fignvim.lsp.capabilities.on_dynamic_capability(fignvim.lsp.check_methods)
  fignvim.lsp.capabilities.on_dynamic_capability(fignvim.lsp.mappings.on_attach)

  -- 3. Wire up check for supported methods for each client when attaching.
  --    Caches the results in fignvim.lsp.supports_method table
  fignvim.lsp.on_attach(fignvim.lsp.check_methods)

  -- 4. Setup common things when clients attach
  fignvim.lsp.on_attach(function(client, bufnr)
    -- a. Setup mappings for the buffer
    fignvim.lsp.mappings.on_attach(client, bufnr)

    -- b. Setup symbol highlights
    if client.server_capabilities.documentHighlightProvider then
      fignvim.lsp.handlers.handle_document_highlighting(bufnr)
    end

    -- c. Setup signature help
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
  end)

  -- 5. Setup inlay hints
  if opts.inlay_hints.enabled then
    fignvim.lsp.on_supports_method("textDocument/inlayHint", function(_, buffer)
      if
        vim.api.nvim_buf_is_valid(buffer)
        and vim.bo[buffer].buftype == ""
        and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
      then
        vim.lsp.inlay_hint.enable(vim.g.inlay_hint_default_enable, { bufnr = buffer })
      end
    end)
  end

  -- 6. Setup code lens
  if opts.codelens.enabled and vim.lsp.codelens then
    fignvim.lsp.on_supports_method("textDocument/codeLens", function(_, buffer)
      vim.lsp.codelens.refresh()
      vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
        buffer = buffer,
        callback = vim.lsp.codelens.refresh,
      })
    end)
  end

  -- 7. Setup diagnostics
  if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
    opts.diagnostics.virtual_text.prefix = function(diagnostic)
      local icons = require("icons").diagnostics
      for d, icon in pairs(icons) do
        if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
          return icon
        end
      end
    end
  end

  vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

  -- 6. Setup LSP servers
  fignvim.lsp.servers.setup_lsp_servers({
    "jsonls",
    "cucumber_language_server",
    "ts_ls",
    "lua_ls",
    "texlab",
    "roslyn",
    "terraformls",
    "stylelint_lsp",
    "emmet_ls",
    "bashls",
    "dockerls",
    "docker_compose_language_service",
    "html",
    "vimls",
    "yamlls",
    "angularls",
    "cssls",
    "tflint",
    "powershell_es",
    "eslint",
    "clangd",
    "cmake",
    "pyright",
    "tailwindcss",
    "helm_ls",
  }, client_capabilities)
end
