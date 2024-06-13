local surrounds = require("plugins.heirline-components.surrounds")
local space_component = require("plugins.heirline-components.space-component")

local ScrollBar = {
  static = {
    sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
  },
  hl = {
    fg = "scrollbar",
    bg = "component_bg",
  },

  surrounds.LeftSlantStart,
  space_component,
  {
    provider = function(self)
      local curr_line = vim.api.nvim_win_get_cursor(0)[1]
      local lines = vim.api.nvim_buf_line_count(0)
      local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
      return string.rep(self.sbar[i], 2)
    end,
  },
  space_component,
  surrounds.LeftSlantEnd,
}

return ScrollBar
