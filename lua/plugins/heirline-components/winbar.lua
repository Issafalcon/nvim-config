local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local space_component = require("plugins.heirline-components.space-component")
local terminal_name_component =
  require("plugins.heirline-components.terminal-name-component")
local filename_component = require("plugins.heirline-components.filename")

local WinBars = {
  fallthrough = false,
  { -- A special winbar for terminals
    condition = function()
      return conditions.buffer_matches({ buftype = { "terminal" } })
    end,
    utils.surround({ "", "" }, "red", {
      space_component,
      terminal_name_component,
    }),
  },
  { -- An inactive winbar for regular files
    condition = function()
      return not conditions.is_active()
    end,
    utils.surround(
      { "", "" },
      "component_fg",
      { hl = { fg = "gray", force = true }, FileNameBlock }
    ),
  },
  -- A winbar for regular files
  utils.surround({ "", "" }, "component_bg", FileNameBlock),
}

return WinBars
