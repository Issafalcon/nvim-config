local lsp_config_spec = {
  "neovim/nvim-lspconfig",
  event = "BufReadPre",
  dependencies = {
    "lsp-overloads.nvim",
    "mason.nvim",
    -- LSP Completion sources
    "hrsh7th/cmp-nvim-lsp",
    -- Typescript LSP Enhancements
    "jose-elias-alvarez/nvim-lsp-ts-utils",
  },
}

local null_ls_spec = {
  "jose-elias-alvarez/null-ls.nvim",
  event = "BufReadPre",
  dependencies = { "mason.nvim" },
  opts = function()
    local null_ls = require("null-ls")
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics
    local code_actions = null_ls.builtins.code_actions

    return {
      debug = true,
      sources = {
        formatting.prettier.with({ extra_args = { "--single-quote", "--jsx-single-quote" } }),
        formatting.black.with({ extra_args = { "--fast" } }),
        formatting.stylua,
        -- Use project-local exe only
        -- https://github.com/jose-elias-alvarez/nvim-lsp-ts-utils#configuring-sources
        formatting.eslint_d.with({
          only_local = "node_modules/.bin",
        }),
        formatting.shfmt,
        formatting.markdownlint,
        diagnostics.yamllint,
        diagnostics.shellcheck,
        diagnostics.vint,
        diagnostics.eslint_d.with({
          only_local = "node_modules/.bin",
        }),
        diagnostics.chktex,
        code_actions.eslint.with({
          prefer_local = "node_modules/.bin",
        }),
        code_actions.refactoring,
      },
      on_attach = fignvim.lsp.on_attach,
    }
  end,
}

local mason_spec = {
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
}

-- Signature helper LSP enhancements
local lsp_overloads_spec = {
  "Issafalcon/lsp-overloads.nvim",
  event = "VeryLazy",
}

return fignvim.module.enable_registered_plugins({
  ["lsp_config"] = lsp_config_spec,
  ["mason"] = mason_spec,
  ["null-ls"] = null_ls_spec,
  ["lsp-overloads"] = lsp_overloads_spec,
  ["schemastore"] = {
    "b0o/schemastore.nvim",
    ft = "json",
  },
}, "lsp")
