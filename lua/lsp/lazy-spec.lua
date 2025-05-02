local lazydev_config = require("lsp.plugin-config.lazydev")
local lspconfig_config = require("lsp.plugin-config.nvim-lspconfig")
local mason_config = require("lsp.plugin-config.mason")
local mason_lspconfig_config = require("lsp.plugin-config.mason-lspconfig")
local mason_tool_installer_config = require("lsp.plugin-config.mason-tool-installer")
local workspace_diagnostics_config = require("lsp.plugin-config.workspace-diagnostics")

return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = lazydev_config.lazy_opts,
  },

  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "lazydev.nvim",
      "lsp-overloads.nvim",
      "mason.nvim",
      -- LSP Completion sources
      "hrsh7th/cmp-nvim-lsp",
      -- Typescript LSP Enhancements
      "jose-elias-alvarez/nvim-lsp-ts-utils",
    },
    opts = lspconfig_config.lazy_opts,
    config = function(_, opts)
      fignvim.lsp.setup(opts)
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    dependencies = {
      -- Enhancements for Mason for autoinstallation of LSP servers
      {
        "williamboman/mason-lspconfig.nvim",
        opts = mason_lspconfig_config.lazy_opts,
      },
      -- Mason tools installer enhancements
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts = mason_tool_installer_config.lazy_opts,
      },
    },
    opts = mason_config.lazy_opts,
  },
  {
    "artemave/workspace-diagnostics.nvim",
    event = "LspAttach",
    config = workspace_diagnostics_config.lazy_config,
  },
}
