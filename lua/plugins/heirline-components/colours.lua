local M = {}

local C = require("core.colourscheme").colours

function M.setup_colors()
  local Normal = fignvim.ui.get_hlgroup("Normal", { fg = C.fg, bg = C.bg })
  local Comment = fignvim.ui.get_hlgroup("Comment", { fg = C.grey_2, bg = C.bg })
  local Error = fignvim.ui.get_hlgroup("Error", { fg = C.red, bg = C.bg })
  local StatusLine = fignvim.ui.get_hlgroup("StatusLine", { fg = C.fg, bg = C.grey_4 })
  local TabLine = fignvim.ui.get_hlgroup("TabLine", { fg = C.grey, bg = C.none })
  local TabLineSel = fignvim.ui.get_hlgroup("TabLineSel", { fg = C.fg, bg = C.none })
  local WinBar = fignvim.ui.get_hlgroup("WinBar", { fg = C.grey_2, bg = C.bg })
  local WinBarNC = fignvim.ui.get_hlgroup("WinBarNC", { fg = C.grey, bg = C.bg })
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
  local HeirlineInactive = fignvim.ui.get_hlgroup("HeirlineInactive", { fg = nil }).fg
  local HeirlineNormal = fignvim.ui.get_hlgroup("HeirlineNormal", { fg = nil }).fg
  local HeirlineInsert = fignvim.ui.get_hlgroup("HeirlineInsert", { fg = nil }).fg
  local HeirlineVisual = fignvim.ui.get_hlgroup("HeirlineVisual", { fg = nil }).fg
  local HeirlineReplace = fignvim.ui.get_hlgroup("HeirlineReplace", { fg = nil }).fg
  local HeirlineCommand = fignvim.ui.get_hlgroup("HeirlineCommand", { fg = nil }).fg
  local HeirlineTerminal = fignvim.ui.get_hlgroup("HeirlineTerminal", { fg = nil }).fg

  local colors = {
    close_fg = Error.fg,
    fg = StatusLine.fg,
    bg = StatusLine.bg,
    section_fg = StatusLine.fg,
    section_bg = StatusLine.bg,
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
    winbar_fg = WinBar.fg,
    winbar_bg = WinBar.bg,
    winbarnc_fg = WinBarNC.fg,
    winbarnc_bg = WinBarNC.bg,
    tabline_bg = StatusLine.bg,
    tabline_fg = StatusLine.bg,
    buffer_fg = Comment.fg,
    buffer_path_fg = WinBarNC.fg,
    buffer_close_fg = Comment.fg,
    buffer_bg = StatusLine.bg,
    buffer_active_fg = Normal.fg,
    buffer_active_path_fg = WinBarNC.fg,
    buffer_active_close_fg = Error.fg,
    buffer_active_bg = Normal.bg,
    buffer_visible_fg = Normal.fg,
    buffer_visible_path_fg = WinBarNC.fg,
    buffer_visible_close_fg = Error.fg,
    buffer_visible_bg = Normal.bg,
    buffer_overflow_fg = Comment.fg,
    buffer_overflow_bg = StatusLine.bg,
    buffer_picker_fg = Error.fg,
    tab_close_fg = Error.fg,
    tab_close_bg = StatusLine.bg,
    tab_fg = TabLine.fg,
    tab_bg = TabLine.bg,
    tab_active_fg = TabLineSel.fg,
    tab_active_bg = TabLineSel.bg,
    inactive = HeirlineInactive,
    normal = HeirlineNormal,
    insert = HeirlineInsert,
    visual = HeirlineVisual,
    replace = HeirlineReplace,
    command = HeirlineCommand,
    terminal = HeirlineTerminal,
    blank_bg = HeirlineInactive,
  }
  return colors
end

return M
