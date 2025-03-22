local conditions = require("heirline.conditions")
local space_component = require("ui.heirline-components.space-component")
local terminal_name_component = require("ui.heirline-components.terminal-name-component")
local filename_component = require("ui.heirline-components.filename")

local WinBars = {
  fallthrough = false,
  { -- A special winbar for terminals
    condition = function()
      return conditions.buffer_matches({ buftype = { "terminal" } })
    end,

    hl = {
      bg = "scrollbar",
    },
    space_component,
    terminal_name_component,
  },
  { -- An inactive winbar for regular files
    condition = function()
      return not conditions.is_active()
    end,
    hl = {
      bg = "none",
      force = true,
    },
    {
      filename_component,
    },
  },
  -- A winbar for regular files
  {
    filename_component,
  },
}

return WinBars
