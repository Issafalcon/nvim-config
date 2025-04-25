---@type FigNvimPluginConfig
local M = {}

M.lazy_opts = {
  cut_key = "m",
  exclude = {},
  registers = {
    select = "_",
    delete = "_",
    change = "_",
  },
}

return M
