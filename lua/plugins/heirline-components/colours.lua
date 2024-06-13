local M = {}

local C = require("core.colourscheme").colours

function M.setup_colors()
  local Error = fignvim.ui.get_hlgroup("Error", { fg = C.red, bg = C.bg })
  local StatusLineComponent =
    fignvim.ui.get_hlgroup("StatusLine", { fg = C.fg, bg = C.grey_4 })
  local Surround = { fg = C.grey_4, bg = C.black_1 }
  local Conditional =
    fignvim.ui.get_hlgroup("Conditional", { fg = C.purple_1, bg = C.grey_4 })
  local String = fignvim.ui.get_hlgroup("String", { fg = C.green, bg = C.grey_4 })
  local TypeDef = fignvim.ui.get_hlgroup("TypeDef", { fg = C.yellow, bg = C.grey_4 })
  local GitSignsAdd =
    fignvim.ui.get_hlgroup("GitSignsAdd", { fg = C.green, bg = C.grey_4 })
  local GitSignsChange =
    fignvim.ui.get_hlgroup("GitSignsChange", { fg = C.orange_1, bg = C.grey_4 })
  local GitSignsDelete =
    fignvim.ui.get_hlgroup("GitSignsDelete", { fg = C.red_1, bg = C.grey_4 })
  local DiagnosticError =
    fignvim.ui.get_hlgroup("DiagnosticError", { fg = C.red_1, bg = C.grey_4 })
  local DiagnosticWarn =
    fignvim.ui.get_hlgroup("DiagnosticWarn", { fg = C.orange_1, bg = C.grey_4 })
  local DiagnosticInfo =
    fignvim.ui.get_hlgroup("DiagnosticInfo", { fg = C.white_2, bg = C.grey_4 })
  local DiagnosticHint =
    fignvim.ui.get_hlgroup("DiagnosticHint", { fg = C.yellow_1, bg = C.grey_4 })

  local colors = {
    close_fg = Error.fg,

    component_fg = StatusLineComponent.fg,
    component_bg = StatusLineComponent.bg,

    surround_fg = Surround.fg,
    surround_bg = Surround.bg,

    git_branch_fg = Conditional.fg,

    mode_fg = StatusLineComponent.bg,

    filename_fg = String.fg,
    -- Unused so far
    treesitter_fg = String.fg,

    scrollbar = TypeDef.fg,

    git_added = GitSignsAdd.fg,
    git_changed = GitSignsChange.fg,
    git_removed = GitSignsDelete.fg,

    diag_ERROR = DiagnosticError.fg,
    diag_WARN = DiagnosticWarn.fg,
    diag_INFO = DiagnosticInfo.fg,
    diag_HINT = DiagnosticHint.fg,
  }

  return colors
end

return M
