local surrounds = require("heirline-components.surrounds")

local Ruler = {
  -- %l = current line number
  -- %L = number of lines in the buffer
  -- %c = column number
  -- %P = percentage through file of displayed window
  hl = { fg = "component_fg", bg = "component_bg", italic = true },
  surrounds.RightSlantStart,
  {
    provider = " %7(%l/%3L%):%2c %P ",
  },
  surrounds.RightSlantEnd,
}

return Ruler
