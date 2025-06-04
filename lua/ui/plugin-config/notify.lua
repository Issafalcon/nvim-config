---@type FigNvimPluginConfig
local M = {}

M.lazy_opts = {
  stages = "fade_in_slide_out",
  background_colour = "#000000",
  max_height = function()
    return math.floor(vim.o.lines * 0.75)
  end,
  max_width = function()
    return math.floor(vim.o.columns * 0.75)
  end,
}

M.lazy_config = function(_, opts)
  local notify_plugin = require("notify")
  notify_plugin.setup(opts)
  vim.notify = notify_plugin
end

return M
