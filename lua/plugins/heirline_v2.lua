local StatusLine = {}

local WinBar = { { ... }, { { ... }, { ... } } }

local TabLine = { { ... }, { ... }, { ... } }

-- the winbar parameter is optional!
require("heirline").setup({
  statusline = StatusLine,
  winbar = WinBar,
  tabline = TabLine,
  statuscolumn = {},
  opts = { ... }, -- other config parameters, see below
})
