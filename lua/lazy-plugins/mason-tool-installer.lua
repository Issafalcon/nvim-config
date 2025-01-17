require("mason-tool-installer").setup({
  ensure_installed = {
    -- Formatters
    "jq",
    "prettier",
    "prettierd",
    "shfmt",
    "sql-formatter",
    "sqlfluff",
    "stylua",
    "clang-format",
    "black",
    "yamlfmt",
    -- "ruff",

    -- Linters
    "tflint",
    "editorconfig-checker",
    "eslint_d",
    "markdownlint",
    "shellcheck",
    "vint",
    "yamllint",

    -- Debuggers
    "debugpy",
    "netcoredbg",
  },
})
