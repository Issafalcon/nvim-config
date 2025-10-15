---@type FigNvimPluginConfig
local M = {}

M.lazy_config = function()
  require("lsp-progress").setup()
end

return M
