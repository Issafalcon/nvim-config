return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    dependencies = {
      -- Enhancements for Mason for autoinstallation of LSP servers
      {
        "williamboman/mason-lspconfig.nvim",
        opts = {
          -- Automatically install all servers setup via lsp-config
          automatic_installation = true,
        },
      },
      -- Mason tools installer enhancements
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts = {
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
          },
        },
      },
    },
    opts = {
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
    },
  },
}
