local lazydev_config = require("lsp.plugin-config.lazydev")
local lspconfig_config = require("lsp.plugin-config.nvim-lspconfig")
local mason_config = require("lsp.plugin-config.mason")
local mason_tool_installer_config = require("lsp.plugin-config.mason-tool-installer")
local lsp_progress_config = require("lsp.plugin-config.lsp-progress")
local terragrunt_ls_config = require("lsp.plugin-config.terragrunt-ls")

return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "nvim-navic",
      "lsp-overloads.nvim",
      -- LSP Completion sources
      "hrsh7th/cmp-nvim-lsp",
      -- Typescript LSP Enhancements
      "jose-elias-alvarez/nvim-lsp-ts-utils",
      "mason.nvim",
    },
    opts = lspconfig_config.lazy_opts,
    config = function(_, opts)
      fignvim.lsp.setup(opts)
    end,
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

  {
    "gruntwork-io/terragrunt-ls",
    ft = "hcl",
    build = "go build -o " .. vim.fn.stdpath("data") .. "/mason/bin/terragrunt-ls",
    opts = terragrunt_ls_config.lazy_opts,
    config = terragrunt_ls_config.lazy_config,
  },
}
