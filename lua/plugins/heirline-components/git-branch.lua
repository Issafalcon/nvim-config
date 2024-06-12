local conditions = require("heirline.conditions")
local surrounds = require("plugins.heirline-components.surrounds")

local Git = {
  condition = conditions.is_git_repo,

  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0
      or self.status_dict.removed ~= 0
      or self.status_dict.changed ~= 0
  end,

  hl = { fg = "git_branch_fg", bg = "bg" },

  surrounds.LeftSlantStart,
  { -- git branch name
    provider = function(self)
      return " " .. self.status_dict.head
    end,
    hl = { bold = true },
  },
  -- You could handle delimiters, icons and counts similar to Diagnostics
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = "(",
  },
  {
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and (fignvim.ui.get_icon("GitAdd") .. " " .. count)
    end,
    hl = { fg = "git_added", bg = "bg" },
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and (fignvim.ui.get_icon("GitDelete") .. count)
    end,
    hl = { fg = "git_removed" },
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and (fignvim.ui.get_icon("GitChange") .. count)
    end,
    hl = { fg = "git_changed" },
  },
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = ")",
  },
  surrounds.LeftSlantEnd,
}

return Git
