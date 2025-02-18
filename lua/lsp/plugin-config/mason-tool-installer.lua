---@type FigNvimPluginConfig
local M = {}

M.lazy_opts = {
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
}

M.setup = function()
  require("mason-tool-installer").setup(M.lazy_opts)
end

return M
