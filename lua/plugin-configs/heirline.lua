local heirline = fignvim.plug.load_module_file("heirline")
if not heirline or not fignvim.status then
  return
end
local C = rere("user-configs").colours

local function setup_colors()
  local StatusLine = fignvim.get_hlgroup("StatusLine", { fg = C.fg, bg = C.grey_4 })
  local WinBar = fignvim.get_hlgroup("WinBar", { fg = C.grey_2, bg = C.bg })
  local WinBarNC = fignvim.get_hlgroup("WinBarNC", { fg = C.grey, bg = C.bg })
  local Conditional = fignvim.get_hlgroup("Conditional", { fg = C.purple_1, bg = C.grey_4 })
  local String = fignvim.get_hlgroup("String", { fg = C.green, bg = C.grey_4 })
  local TypeDef = fignvim.get_hlgroup("TypeDef", { fg = C.yellow, bg = C.grey_4 })
  local HeirlineNormal = fignvim.get_hlgroup("HerlineNormal", { fg = C.blue, bg = C.grey_4 })
  local HeirlineInsert = fignvim.get_hlgroup("HeirlineInsert", { fg = C.green, bg = C.grey_4 })
  local HeirlineVisual = fignvim.get_hlgroup("HeirlineVisual", { fg = C.purple, bg = C.grey_4 })
  local HeirlineReplace = fignvim.get_hlgroup("HeirlineReplace", { fg = C.red_1, bg = C.grey_4 })
  local HeirlineCommand = fignvim.get_hlgroup("HeirlineCommand", { fg = C.yellow_1, bg = C.grey_4 })
  local HeirlineInactive = fignvim.get_hlgroup("HeirlineInactive", { fg = C.grey_7, bg = C.grey_4 })
  local GitSignsAdd = fignvim.get_hlgroup("GitSignsAdd", { fg = C.green, bg = C.grey_4 })
  local GitSignsChange = fignvim.get_hlgroup("GitSignsChange", { fg = C.orange_1, bg = C.grey_4 })
  local GitSignsDelete = fignvim.get_hlgroup("GitSignsDelete", { fg = C.red_1, bg = C.grey_4 })
  local DiagnosticError = fignvim.get_hlgroup("DiagnosticError", { fg = C.red_1, bg = C.grey_4 })
  local DiagnosticWarn = fignvim.get_hlgroup("DiagnosticWarn", { fg = C.orange_1, bg = C.grey_4 })
  local DiagnosticInfo = fignvim.get_hlgroup("DiagnosticInfo", { fg = C.white_2, bg = C.grey_4 })
  local DiagnosticHint = fignvim.get_hlgroup("DiagnosticHint", { fg = C.yellow_1, bg = C.grey_4 })
  local colors = {
    fg = StatusLine.fg,
    bg = StatusLine.bg,
    section_fg = StatusLine.fg,
    section_bg = StatusLine.bg,
    git_branch_fg = Conditional.fg,
    treesitter_fg = String.fg,
    scrollbar = TypeDef.fg,
    git_added = GitSignsAdd.fg,
    git_changed = GitSignsChange.fg,
    git_removed = GitSignsDelete.fg,
    diag_ERROR = DiagnosticError.fg,
    diag_WARN = DiagnosticWarn.fg,
    diag_INFO = DiagnosticInfo.fg,
    diag_HINT = DiagnosticHint.fg,
    normal = HeirlineNormal.fg,
    insert = HeirlineInsert.fg,
    visual = HeirlineVisual.fg,
    replace = HeirlineReplace.fg,
    command = HeirlineCommand.fg,
    inactive = HeirlineInactive.fg,
    winbar_fg = WinBar.fg,
    winbar_bg = WinBar.bg,
    winbarnc_fg = WinBarNC.fg,
    winbarnc_bg = WinBarNC.bg,
  }

  for _, section in ipairs({
    "git_branch",
    "file_info",
    "git_diff",
    "diagnostics",
    "lsp",
    "macro_recording",
    "treesitter",
    "nav",
  }) do
    if not colors[section .. "_bg"] then
      colors[section .. "_bg"] = colors["section_bg"]
    end
    if not colors[section .. "_fg"] then
      colors[section .. "_fg"] = colors["section_fg"]
    end
  end
  return colors
end

heirline.load_colors(setup_colors())
local heirline_opts = {
  {
    hl = { fg = "fg", bg = "bg" },
    fignvim.status.component.mode(),
    fignvim.status.component.git_branch(),
    fignvim.status.component.file_info(
      fignvim.plug.is_available("bufferline.nvim") and { filetype = {}, filename = false, file_modified = false } or nil
    ),
    fignvim.status.component.git_diff(),
    fignvim.status.component.diagnostics(),
    fignvim.status.component.fill(),
    fignvim.status.component.macro_recording(),
    fignvim.status.component.fill(),
    fignvim.status.component.lsp(),
    fignvim.status.component.treesitter(),
    fignvim.status.component.nav(),
    fignvim.status.component.mode({ surround = { separator = "right" } }),
  },
  {
    fallthrough = false,
    {
      condition = function()
        return fignvim.status.condition.buffer_matches({
          buftype = { "terminal", "prompt", "nofile", "help", "ckfix" },
          filetype = { "NvimTree", "neo-tree", "dashboard", "Outline", "aerial" },
        })
      end,
      init = function()
        vim.opt_local.winbar = nil
      end,
    },
    {
      condition = fignvim.status.condition.is_active,
      fignvim.status.component.breadcrumbs({ hl = { fg = "winbar_fg", bg = "winbar_bg" } }),
    },
    fignvim.status.component.file_info({
      file_icon = { highlight = false },
      hl = { fg = "winbarnc_fg", bg = "winbarnc_bg" },
      surround = false,
    }),
  },
}

heirline.setup(heirline_opts[1], heirline_opts[2])

vim.api.nvim_create_augroup("Heirline", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = "Heirline",
  desc = "Refresh heirline colors",
  callback = function()
    heirline.reset_highlights()
    heirline.load_colors(setup_colors())
  end,
})
