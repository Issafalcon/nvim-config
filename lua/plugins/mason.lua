vim.pack.add({
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
})

require("mason").setup({
  registries = {
    "github:mason-org/mason-registry",
    "github:Crashdummyy/mason-registry",
  },
  providers = {
    "mason.providers.registry-api",
    "mason.providers.client",
  },
  ui = {
    icons = {
      package_installed = "✓",
      package_uninstalled = "✗",
      package_pending = "⟳",
    },
  },
})

require("mason-tool-installer").setup({
  ensure_installed = {
    -- LSPs
    "lua-language-server",
    "copilot-language-server",
    "bash-language-server",
    "cucumber-language-server",
    "roslyn",
    "vtsls", -- vscode typescript language features
    "json-lsp",
    "angular-language-server",
    "helm-ls",
    "pyright",

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
    "kulala-fmt",

    -- Linters
    "tflint",
    "editorconfig-checker",
    "eslint_d",
    "markdownlint",
    "shellcheck",
    "vint",
    "yamllint",
    "ansible-lint",

    -- Debuggers
    "debugpy",
    "netcoredbg",
    "js-debug-adapter",
  },
})
