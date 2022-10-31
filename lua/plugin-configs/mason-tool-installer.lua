local mason_tool = fignvim.plug.load_module_file("mason-tool-installer")
if not mason_tool then
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
    "yamllint",
  },
})
