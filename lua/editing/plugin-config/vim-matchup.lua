---@type FigNvimPluginConfig
local M = {}

M.lazy_config = function()
  vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
end

return M
