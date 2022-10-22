local lsp_status = require("lsp-status")
lsp_status.register_progress()

local M = {}
-- TODO: backfill this to template
M.setup = function()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    -- show signs
    signs = {
      active = signs,
    },
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })

  -- Diagnostics handlers
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    signs = true,
    update_in_insert = false,
    virtual_text = false,
  })
end

local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
      false
    )
  end
end

local function lsp_keymaps(bufnr, client)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  local opts = { noremap = true, silent = true }

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  if client.name == "omnisharp" then
    buf_set_keymap("n", "<leader>ac", ":OmnisharperGlobalDiagnostics<CR>", opts)
  end
  -- Native lsp
  buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "<leader>gi", ":lua require('telescope.builtin').lsp_implementations()<CR>", opts)
  buf_set_keymap("n", "gr", ":lua require('telescope.builtin').lsp_references()<CR>", opts)
  buf_set_keymap("n", "gm", ":lua require('telescope.builtin').lsp_document_symbols()<CR>", opts)
  buf_set_keymap("n", "<leader>ac", ":lua require('telescope.builtin').diagnostics()<CR>", opts)
  buf_set_keymap("n", "K", ":Lspsaga hover_doc<CR>", opts)
  buf_set_keymap("n", "rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

  buf_set_keymap("n", "<Leader>f", "<cmd>lua vim.lsp.buf.formatting_sync({}, 2000)<CR>", opts)

  buf_set_keymap("v", "<Leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)

  buf_set_keymap("n", "<A-s>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("i", "<A-s>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "<leader>ca", ":Lspsaga code_action<CR>", opts)
  buf_set_keymap("v", "<leader>ca", ":<C-U>Lspsaga code_action<CR>", opts)
  buf_set_keymap("n", "<leader>sd", ":lua require('telescope.builtin').lsp_definitions()<CR>", opts)
  buf_set_keymap("n", "<leader>gh", ":Lspsaga lsp_finder<CR>", opts)
  buf_set_keymap("n", "[g", ":lua vim.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]g", ":lua vim.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "<leader>so", ":LSoutlineToggle<CR>", opts)
  buf_set_keymap("n", "<C-f>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>", opts)
  buf_set_keymap("n", "<C-b>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>", opts)

  -- Additional LSP extension mappings
  if client.name == "tsserver" then
    buf_set_keymap("n", "<leader>to", ":TSLspOrganize<CR>", opts)
    buf_set_keymap("n", "<leader>trn", ":TSLspRenameFile<CR>", opts)
    buf_set_keymap("n", "<leader>ti", ":TSLspImportAll<CR>", opts)
  end

  vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
end

M.on_attach = function(client, bufnr)
  if client.name == "tsserver" then
    client.server_capabilities.document_formatting = false

    local ts_utils = require("nvim-lsp-ts-utils")
    ts_utils.setup({})
    ts_utils.setup_client(client)

    local clients = vim.lsp.buf_get_clients(bufnr)
    for _, other_client in pairs(clients) do
      if other_client.name == "angularls" then
        -- Prevent tsserver rename duplication when angularls is in use
        client.server_capabilities.rename = false
      end
    end
  end

  if client.name == "angularls" then
    local clients = vim.lsp.buf_get_clients(bufnr)
    for _, other_client in pairs(clients) do
      if other_client.name == "tsserver" then
        -- Prevent tsserver rename duplication when angularls is in use
        other_client.server_capabilities.rename = false
      end
    end
  end

  if client.name == "omnisharp" then
    -- Experimental plugin I'm working on
    require("neosharper").on_attach({}, bufnr)
  end

  if client.name == "sqls" then
    print("Attaching sqls plugin")
    require("sqls").on_attach(client, bufnr)
  end

  if client.server_capabilities.signatureHelpProvider then
    require("lsp-overloads").setup(client, {})
  end

  lsp_status.on_attach(client)
  lsp_keymaps(bufnr, client)
  lsp_highlight_document(client)
end

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
  return
end

M.capabilities = vim.tbl_deep_extend("force", cmp_nvim_lsp.default_capabilities(), lsp_status.capabilities)

return M
