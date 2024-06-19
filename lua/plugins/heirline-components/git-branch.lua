local conditions = require("heirline.conditions")
local surrounds = require("plugins.heirline-components.surrounds")

local Git = {
  condition = conditions.is_git_repo,

  init = function(self)
    ---@diagnostic disable-next-line: undefined-field
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0
      or self.status_dict.removed ~= 0
      or self.status_dict.changed ~= 0
  end,

  hl = { fg = "git_branch_fg", bg = "component_bg", bold = true },

  on_click = {
    callback = function()
      -- If you want to use Fugitive:
      -- vim.cmd("G")

      -- If you prefer Lazygit
      -- use vim.defer_fn() if the callback requires
      -- opening of a floating window
      -- (this also applies to telescope)
      vim.defer_fn(function()
        fignvim.term.toggle_term_cmd("lazygit")
      end, 100)
    end,
    name = "heirline_git",
  },

  surrounds.LeftSlantStart,
  { -- git branch name
    provider = function(self)
      return "  " .. self.status_dict.head
    end,
  },
  -- You could handle delimiters, icons and counts similar to Diagnostics
  {
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and " " .. (fignvim.ui.get_icon("GitAdd") .. " " .. count)
    end,
    hl = { fg = "git_added" },
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and " " .. (fignvim.ui.get_icon("GitDelete") .. " " .. count)
    end,
    hl = { fg = "git_removed" },
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and " " .. (fignvim.ui.get_icon("GitChange") .. " " .. count)
    end,
    hl = { fg = "git_changed" },
  },
  surrounds.LeftSlantEnd,
}

return Git
