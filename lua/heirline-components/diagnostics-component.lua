local conditions = require("heirline.conditions")
local space_component = require("heirline-components.space-component")
local surrounds = require("heirline-components.surrounds")

local Diagnostics = {

  condition = conditions.has_diagnostics,

  static = {
    error_icon = fignvim.ui.get_icon("DiagnosticError"),
    warn_icon = fignvim.ui.get_icon("DiagnosticWarn"),
    info_icon = fignvim.ui.get_icon("DiagnosticInfo"),
    hint_icon = fignvim.ui.get_icon("DiagnosticHint"),
  },

  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,

  update = { "DiagnosticChanged", "BufEnter" },

  hl = { bg = "component_bg" },

  surrounds.RightSlantStart,
  space_component,
  {
    provider = function(self)
      -- 0 is just another output, we can decide to print it or not!
      return self.errors > 0 and (self.error_icon .. " " .. self.errors .. " ")
    end,
    hl = { fg = "diag_error" },
  },
  {
    provider = function(self)
      return self.warnings > 0 and (self.warn_icon .. " " .. self.warnings .. " ")
    end,
    hl = { fg = "diag_warn" },
  },
  {
    provider = function(self)
      return self.info > 0 and (self.info_icon .. " " .. self.info .. " ")
    end,
    hl = { fg = "diag_info" },
  },
  {
    provider = function(self)
      return self.hints > 0 and (self.hint_icon .. " " .. self.hints)
    end,
    hl = { fg = "diag_hint" },
  },

  space_component,
  surrounds.RightSlantEnd,
}

return Diagnostics
