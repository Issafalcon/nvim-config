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
