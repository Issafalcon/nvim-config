local C = require("core.colourscheme").colours

local function setup_colors()
  local Normal = fignvim.ui.get_hlgroup("Normal", { fg = C.fg, bg = C.bg })
  local Comment = fignvim.ui.get_hlgroup("Comment", { fg = C.grey_2, bg = C.bg })
  local Error = fignvim.ui.get_hlgroup("Error", { fg = C.red, bg = C.bg })
  local StatusLine = fignvim.ui.get_hlgroup("StatusLine", { fg = C.fg, bg = C.grey_4 })
  local TabLine = fignvim.ui.get_hlgroup("TabLine", { fg = C.grey, bg = C.none })
  local TabLineSel = fignvim.ui.get_hlgroup("TabLineSel", { fg = C.fg, bg = C.none })
  local WinBar = fignvim.ui.get_hlgroup("WinBar", { fg = C.grey_2, bg = C.bg })
  local WinBarNC = fignvim.ui.get_hlgroup("WinBarNC", { fg = C.grey, bg = C.bg })
  local Conditional = fignvim.ui.get_hlgroup("Conditional", { fg = C.purple_1, bg = C.grey_4 })
  local String = fignvim.ui.get_hlgroup("String", { fg = C.green, bg = C.grey_4 })
  local TypeDef = fignvim.ui.get_hlgroup("TypeDef", { fg = C.yellow, bg = C.grey_4 })
  local GitSignsAdd = fignvim.ui.get_hlgroup("GitSignsAdd", { fg = C.green, bg = C.grey_4 })
  local GitSignsChange = fignvim.ui.get_hlgroup("GitSignsChange", { fg = C.orange_1, bg = C.grey_4 })
  local GitSignsDelete = fignvim.ui.get_hlgroup("GitSignsDelete", { fg = C.red_1, bg = C.grey_4 })
  local DiagnosticError = fignvim.ui.get_hlgroup("DiagnosticError", { fg = C.red_1, bg = C.grey_4 })
  local DiagnosticWarn = fignvim.ui.get_hlgroup("DiagnosticWarn", { fg = C.orange_1, bg = C.grey_4 })
  local DiagnosticInfo = fignvim.ui.get_hlgroup("DiagnosticInfo", { fg = C.white_2, bg = C.grey_4 })
  local DiagnosticHint = fignvim.ui.get_hlgroup("DiagnosticHint", { fg = C.yellow_1, bg = C.grey_4 })
  local HeirlineInactive = fignvim.ui.get_hlgroup("HeirlineInactive", { fg = nil }).fg
    or fignvim.status.hl.lualine_mode("inactive", C.grey_7)
  local HeirlineNormal = fignvim.ui.get_hlgroup("HeirlineNormal", { fg = nil }).fg or fignvim.status.hl.lualine_mode("normal", C.blue)
  local HeirlineInsert = fignvim.ui.get_hlgroup("HeirlineInsert", { fg = nil }).fg or fignvim.status.hl.lualine_mode("insert", C.green)
  local HeirlineVisual = fignvim.ui.get_hlgroup("HeirlineVisual", { fg = nil }).fg or fignvim.status.hl.lualine_mode("visual", C.purple)
  local HeirlineReplace = fignvim.ui.get_hlgroup("HeirlineReplace", { fg = nil }).fg or fignvim.status.hl.lualine_mode("replace", C.red_1)
  local HeirlineCommand = fignvim.ui.get_hlgroup("HeirlineCommand", { fg = nil }).fg
    or fignvim.status.hl.lualine_mode("command", C.yellow_1)
  local HeirlineTerminal = fignvim.ui.get_hlgroup("HeirlineTerminal", { fg = nil }).fg
    or fignvim.status.hl.lualine_mode("inactive", HeirlineInsert)

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
    blank_bg = HeirlineInactive.bg,
  }

  for _, section in ipairs({
    "git_branch",
    "file_info",
    "git_diff",
    "diagnostics",
    "lsp",
    "macro_recording",
    "mode",
    "cmd_info",
    "treesitter",
    "nav",
  }) do
    if not colors[section .. "_bg"] then colors[section .. "_bg"] = colors["section_bg"] end
    if not colors[section .. "_fg"] then colors[section .. "_fg"] = colors["section_fg"] end
  end
  return colors
end

return {
  {
    "rebelot/heirline.nvim",
    event = "UIEnter",
    config = function()
      local heirline = require("heirline")

      -- Load helper functions API
      require("api.status")

      if not fignvim.status then return end

      heirline.load_colors(setup_colors())

      local heirline_opts = {
        { -- statusline
          hl = { fg = "fg", bg = "bg" },
          fignvim.status.component.mode(),
          fignvim.status.component.git_branch(),
          fignvim.status.component.file_info(),
          -- fignvim.status.component.file_info { filetype = {}, filename = false, file_modified = false },
          fignvim.status.component.git_diff(),
          fignvim.status.component.diagnostics(),
          fignvim.status.component.fill(),
          fignvim.status.component.cmd_info(),
          fignvim.status.component.fill(),
          fignvim.status.component.lsp(),
          fignvim.status.component.treesitter(),
          fignvim.status.component.nav(),
          fignvim.status.component.mode({ surround = { separator = "right" } }),
        },
        { -- winbar
          static = {
            disabled = {
              buftype = { "terminal", "prompt", "nofile", "help", "quickfix" },
              filetype = { "rnvimr", "NvimTree", "neo%-tree", "dashboard", "Outline", "aerial" },
            },
          },
          init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
          fallthrough = false,
          {
            condition = function(self) return vim.opt.diff:get() or fignvim.status.condition.buffer_matches(self.disabled or {}) end,
            init = function() vim.opt_local.winbar = nil end,
          },
          fignvim.status.component.file_info({
            condition = function() return not fignvim.status.condition.is_active() end,
            unique_path = {},
            file_icon = { hl = fignvim.status.hl.file_icon("winbar") },
            file_modified = false,
            file_read_only = false,
            hl = fignvim.status.hl.get_attributes("winbarnc", true),
            surround = false,
            update = "BufEnter",
          }),
          fignvim.status.component.breadcrumbs({ hl = fignvim.status.hl.get_attributes("winbar", true) }),
        },
      }

      heirline.setup({ statusline = heirline_opts[1] })

      local augroup = vim.api.nvim_create_augroup("Heirline", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = augroup,
        desc = "Refresh heirline colors",
        callback = function() require("heirline.utils").on_colorscheme(setup_colors()) end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "HeirlineInitWinbar",
        group = augroup,
        desc = "Disable winbar for some filetypes",
        callback = function()
          if
            vim.opt.diff:get()
            or fignvim.status.condition.buffer_matches(require("heirline").winbar.disabled or {
              buftype = { "terminal", "prompt", "nofile", "help", "quickfix" },
              filetype = { "rnvimr", "NvimTree", "neo%-tree", "dashboard", "Outline", "aerial" },
            })
          then
            vim.opt_local.winbar = nil
          end
        end,
      })
    end,
  },
}
