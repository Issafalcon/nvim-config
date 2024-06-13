local surrounds = require("plugins.heirline-components.surrounds")

local WorkDir = {
  init = function(self)
    self.icon = "  "
    local cwd = vim.fn.getcwd(0)
    self.cwd = vim.fn.fnamemodify(cwd, ":~")
  end,

  flexible = 1,

  {
    surrounds.LeftSlantStart,
    {
      hl = { fg = "component_fg", bg = "component_bg", bold = true },
      -- evaluates to the full-lenth path
      provider = function(self)
        local trail = self.cwd:sub(-1) == "/" and "" or "/"
        return self.icon .. self.cwd .. trail .. " "
      end,
    },
    surrounds.LeftSlantEnd,
  },
  {
    -- evaluates to the shortened path
    surrounds.LeftSlantStart,
    {
      hl = { fg = "component_fg", bg = "component_bg", bold = true },
      provider = function(self)
        local cwd = vim.fn.pathshorten(self.cwd)
        local trail = self.cwd:sub(-1) == "/" and "" or "/"
        return self.icon .. cwd .. trail .. " "
      end,
    },
    surrounds.LeftSlantEnd,
  },
  {
    -- evaluates to "", hiding the component
    provider = "",
  },
}

return WorkDir
