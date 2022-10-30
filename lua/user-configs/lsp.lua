local M = {}

M.servers = {
  "jsonls",
  "cucumber_language_server",
  "tsserver",
  "sumneko_lua",
  "texlab",
  "omnisharp",
  "terraformls",
  "stylelint_lsp",
  "emmet_ls",
  "bashls",
  "dockerls",
  "html",
  "vimls",
  "yamlls",
  "angularls",
  "cssls",
  "tflint",
  "sqls",
}

M.formatting = {
  format_on_save = {
    -- Enable / disable formatting globally
    enabled = true,
    -- Enable / disable formatting on save for specific filetypes
    allow_filetypes = {
      "typescript",
      "javascript",
      "javascriptreact",
      "typescriptreact",
      "cs",
      "lua",
    },
    -- Disable formatting on save for specific filetypes
    ignore_filetypes = {},
  },
  -- Disable formatting capabilities for listed language servers
  disabled = {
    "sumneko_lua",
    "tsserver",
  },
  -- Formatting timeout
  timeout_ms = 1000,
}

return M
