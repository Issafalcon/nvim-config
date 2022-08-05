-- Mason setup to add hooks to the native lsp-config setup functions
local mason_status_ok, mason = pcall(require, "mason")
if not mason_status_ok then
  return
end

mason.setup {}

local status_ok, mason_tool = pcall(require, "mason-tool-installer")
if not status_ok then
  return
end

mason_tool.setup({
  ensure_installed = {
    -- Formatters
    "black",
    "jq",
    "prettier",
    "prettierd",
    "shfmt",
    "sql-formatter",
    "stylua",

    -- Linters
    "tflint",
    "editorconfig-checker",
    "eslint_d",
    "flake8",
    "markdownlint",
    "shellcheck",
    "vint",
    "yamllint"
  }
})

local _, mason_lspconfig = pcall(require, "mason-lspconfig")
if mason_lspconfig then
  mason_lspconfig.setup({
    -- Automatically install all servers in the 'servers' array below
    automatic_installation = true
  })
end
