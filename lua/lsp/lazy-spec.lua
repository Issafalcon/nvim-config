local lazydev_config = require("lsp.plugin-config.lazydev")
local lspconfig_config = require("lsp.plugin-config.nvim-lspconfig")
local mason_config = require("lsp.plugin-config.mason")
local mason_lspconfig_config = require("lsp.plugin-config.mason-lspconfig")
local mason_tool_installer_config = require("lsp.plugin-config.mason-tool-installer")
local lsp_progress_config = require("lsp.plugin-config.lsp-progress")

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
      "roslyn.nvim",
      "lazydev.nvim",
      "lsp-overloads.nvim",
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

  -- Enhancements for Mason for autoinstallation of LSP servers
  {
    "mason-org/mason-lspconfig.nvim",
    opts = mason_lspconfig_config.lazy_opts,
    dependencies = {
      "mason.nvim",
      "nvim-lspconfig",
    },
  },

  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    dependencies = {
      -- Mason tools installer enhancements
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts = mason_tool_installer_config.lazy_opts,
      },
    },
    opts = mason_config.lazy_opts,
    config = mason_config.lazy_config,
  },
  {
    "linrongbin16/lsp-progress.nvim",
    config = lsp_progress_config.lazy_config,
  },
  {
    "Issafalcon/lsp-overloads.nvim",
    event = "BufReadPre",
  },
  {
    "b0o/schemastore.nvim",
    ft = "json",
  },
}
