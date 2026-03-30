---@type FigNvimPluginConfig
local M = {}

M.lazy_opts = {
  -- Automatically install all servers setup via lsp-config
  automatic_installation = true,
  automatic_enable = {
    exclude = {
      "roslyn",
    },
  },
}

return M
