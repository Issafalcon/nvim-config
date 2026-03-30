---@type FigNvimPluginConfig
local M = {}

M.lazy_opts = {
  provider = "copilot",
  windows = {
    input = {
      prefix = "▶",
      height = 15,
    },
  },
}

return M
