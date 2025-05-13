-- https://github.com/williamboman/mason.nvim
---@type FigNvimPluginConfig
local M = {}

M.lazy_opts = {
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
}

M.setup = function()
  require("mason").setup(M.lazy_opts)
end

return M
