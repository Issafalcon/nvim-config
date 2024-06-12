local M = {}

local C = require("core.colourscheme").colours

function M.setup_colors()
  local Normal = fignvim.ui.get_hlgroup("Normal", { fg = C.fg, bg = C.bg })
  local Comment = fignvim.ui.get_hlgroup("Comment", { fg = C.grey_2, bg = C.bg })
  local Error = fignvim.ui.get_hlgroup("Error", { fg = C.red, bg = C.bg })
  local StatusLine = fignvim.ui.get_hlgroup("StatusLine", { fg = C.fg, bg = C.grey_8 })
  local Surround = { fg = C.grey_8, bg = C.none }
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

    fg = StatusLine.fg,
    bg = StatusLine.bg,

    surround_fg = Surround.fg,
    surround_bg = Surround.bg,

    git_branch_fg = Conditional.fg,

    mode_fg = StatusLine.bg,

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
