local heirline = fignvim.plug.load_module_file("heirline")
if not heirline or not fignvim.status then
  return
end
local C = require("user-configs.ui").colours

local function setup_colors()
  local StatusLine = fignvim.ui.get_hlgroup("StatusLine", { fg = C.fg, bg = C.grey_4 })
  local WinBar = fignvim.ui.get_hlgroup("WinBar", { fg = C.grey_2, bg = C.bg })
  local WinBarNC = fignvim.ui.get_hlgroup("WinBarNC", { fg = C.grey, bg = C.bg })
  local Conditional = fignvim.ui.get_hlgroup("Conditional", { fg = C.purple_1, bg = C.grey_4 })
  local String = fignvim.ui.get_hlgroup("String", { fg = C.green, bg = C.grey_4 })
  local TypeDef = fignvim.ui.get_hlgroup("TypeDef", { fg = C.yellow, bg = C.grey_4 })
  local HeirlineNormal = fignvim.ui.get_hlgroup("HerlineNormal", { fg = C.blue, bg = C.grey_4 })
  local HeirlineInsert = fignvim.ui.get_hlgroup("HeirlineInsert", { fg = C.green, bg = C.grey_4 })
  local HeirlineVisual = fignvim.ui.get_hlgroup("HeirlineVisual", { fg = C.purple, bg = C.grey_4 })
  local HeirlineReplace = fignvim.ui.get_hlgroup("HeirlineReplace", { fg = C.red_1, bg = C.grey_4 })
  local HeirlineCommand = fignvim.ui.get_hlgroup("HeirlineCommand", { fg = C.yellow_1, bg = C.grey_4 })
  local HeirlineInactive = fignvim.ui.get_hlgroup("HeirlineInactive", { fg = C.grey_7, bg = C.grey_4 })
  local GitSignsAdd = fignvim.ui.get_hlgroup("GitSignsAdd", { fg = C.green, bg = C.grey_4 })
  local GitSignsChange = fignvim.ui.get_hlgroup("GitSignsChange", { fg = C.orange_1, bg = C.grey_4 })
  local GitSignsDelete = fignvim.ui.get_hlgroup("GitSignsDelete", { fg = C.red_1, bg = C.grey_4 })
  local DiagnosticError = fignvim.ui.get_hlgroup("DiagnosticError", { fg = C.red_1, bg = C.grey_4 })
  local DiagnosticWarn = fignvim.ui.get_hlgroup("DiagnosticWarn", { fg = C.orange_1, bg = C.grey_4 })
  local DiagnosticInfo = fignvim.ui.get_hlgroup("DiagnosticInfo", { fg = C.white_2, bg = C.grey_4 })
  local DiagnosticHint = fignvim.ui.get_hlgroup("DiagnosticHint", { fg = C.yellow_1, bg = C.grey_4 })
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
    blank_bg = fignvim.ui.get_hlgroup("Folded").fg,
    file_info_bg = fignvim.ui.get_hlgroup("Visual").bg,
    nav_icon_bg = fignvim.ui.get_hlgroup("String").fg,
    folder_icon_bg = fignvim.ui.get_hlgroup("Error").fg,
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
  -- Statusline
  {
    hl = { fg = "fg", bg = "bg" },
    fignvim.status.component.mode({
      mode_text = { icon = { kind = "VimIcon", padding = { right = 1, left = 1 } } },
      -- define the highlight color for the text
      hl = { fg = "bg" },
      -- surround the component with a separators
      surround = {
        -- it's a left element, so use the left separator
        separator = "left",
        -- set the color of the surrounding based on the current mode using fignvim.status module
        color = function()
          return { main = fignvim.status.hl.mode_bg(), right = "blank_bg" }
        end,
      },
    }),
    -- we want an empty space here so we can use the component builder to make a new section with just an empty string
    fignvim.status.component.builder({
      { provider = "" },
      surround = { separator = "left", color = { main = "blank_bg", right = "file_info_bg" } },
    }),
    -- add a section for the currently opened file information
    fignvim.status.component.file_info({
      filename = {
        fname = function()
          return vim.fn.expand("%")
        end,
        modify = ":.",
      },
      -- enable the file_icon and disable the highlighting based on filetype
      file_icon = { padding = { left = 0 } },
      -- add padding
      padding = { right = 1 },
      -- define the section separator
      surround = { separator = "left", condition = false },
    }),
    fignvim.status.component.git_branch({ surround = { separator = "none" } }),
    fignvim.status.component.git_diff({ padding = { left = 1 }, surround = { separator = "none" } }),
    fignvim.status.component.fill(),
    fignvim.status.component.lsp({ lsp_client_names = false, surround = { separator = "none", color = "bg" } }),
    fignvim.status.component.macro_recording(),
    fignvim.status.component.fill(),
    fignvim.status.component.diagnostics({ surround = { separator = "right" } }),
    fignvim.status.component.lsp({ lsp_progress = false, surround = { separator = "right" } }),
    {
      -- define a simple component where the provider is just a folder icon
      fignvim.status.component.builder({
        { provider = fignvim.ui.get_icon("FolderClosed") },
        padding = { right = 1 },
        hl = { fg = "bg" },
        surround = { separator = "right", color = "folder_icon_bg" },
      }),
      -- add a file information component and only show the current working directory name
      fignvim.status.component.file_info({
        -- we only want filename to be used and we can change the fname
        -- function to get the current working directory name
        filename = {
          fname = function()
            return vim.fn.getcwd()
          end,
          padding = { left = 1 },
        },
        -- disable all other elements of the file_info component
        file_icon = false,
        file_modified = false,
        file_read_only = false,
        -- use no separator for this part but define a background color
        surround = { separator = "none", color = "file_info_bg" },
      }),
    },
    {
      -- define a custom component with just a file icon
      fignvim.status.component.builder({
        { provider = fignvim.ui.get_icon("DefaultFile") },
        -- add padding after icon
        padding = { right = 1 },
        -- set the icon foreground
        hl = { fg = "bg" },
        -- use the right separator and define the background color
        -- as well as the color to the left of the separator
        surround = { separator = "right", color = { main = "nav_icon_bg", left = "file_info_bg" } },
      }),
      -- add a navigation component and just display the percentage of progress in the file
      fignvim.status.component.nav({
        surround = { separator = "none", color = "file_info_bg" },
      }),
    },
  },

  --Winbar
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

local heirline_setup = {}

fignvim.fn.conditional_func(table.insert, vim.g.statusline_enabled, heirline_setup, heirline_opts[1])
fignvim.fn.conditional_func(table.insert, vim.g.winbar_enabled, heirline_setup, heirline_opts[1])

heirline.setup(heirline_setup)

vim.api.nvim_create_augroup("Heirline", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = "Heirline",
  desc = "Refresh heirline colors",
  callback = function()
    heirline.reset_highlights()
    heirline.load_colors(setup_colors())
  end,
})
