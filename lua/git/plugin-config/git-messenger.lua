---@type FigNvimPluginConfig
local M = {}

M.lazy_init = function()
  vim.g.git_messenger_floating_win_opts = { border = "rounded" }
  vim.g.git_messenger_always_into_popup = 1
end

return M
