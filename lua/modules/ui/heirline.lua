local heirline = require("heirline")
local C = require("core.colourscheme.colours")

local function pattern_match(str, pattern_list)
  for _, pattern in ipairs(pattern_list) do
    if str:find(pattern) then return true end
  end
  return false
end

local status = {
  hl = {},
  init = {},
  provider = {},
  condition = {},
  component = {},
  utils = {},
  env = {
    modes = {
      ["n"] = { "NORMAL", "normal" },
      ["no"] = { "OP", "normal" },
      ["nov"] = { "OP", "normal" },
      ["noV"] = { "OP", "normal" },
      ["no␖"] = { "OP", "normal" },
      ["niI"] = { "NORMAL", "normal" },
      ["niR"] = { "NORMAL", "normal" },
      ["niV"] = { "NORMAL", "normal" },
      ["i"] = { "INSERT", "insert" },
      ["ic"] = { "INSERT", "insert" },
      ["ix"] = { "INSERT", "insert" },
      ["t"] = { "TERM", "terminal" },
      ["nt"] = { "TERM", "terminal" },
      ["v"] = { "VISUAL", "visual" },
      ["vs"] = { "VISUAL", "visual" },
      ["V"] = { "LINES", "visual" },
      ["Vs"] = { "LINES", "visual" },
      ["␖"] = { "BLOCK", "visual" },
      ["␖s"] = { "BLOCK", "visual" },
      ["R"] = { "REPLACE", "replace" },
      ["Rc"] = { "REPLACE", "replace" },
      ["Rx"] = { "REPLACE", "replace" },
      ["Rv"] = { "V-REPLACE", "replace" },
      ["s"] = { "SELECT", "visual" },
      ["S"] = { "SELECT", "visual" },
      ["␓"] = { "BLOCK", "visual" },
      ["c"] = { "COMMAND", "command" },
      ["cv"] = { "COMMAND", "command" },
      ["ce"] = { "COMMAND", "command" },
      ["r"] = { "PROMPT", "inactive" },
      ["rm"] = { "MORE", "inactive" },
      ["r?"] = { "CONFIRM", "inactive" },
      ["!"] = { "SHELL", "inactive" },
      ["null"] = { "null", "inactive" },
    },
  },
  separators = {
    none = { "", "" },
    left = { "", "  " },
    right = { "  ", "" },
    center = { "  ", "  " },
    tab = { "", " " },
  },
  attributes = {
    buffer_active = { bold = true, italic = true },
    buffer_picker = { bold = true },
    macro_recording = { bold = true },
    git_branch = { bold = true },
    git_diff = { bold = true },
  },
  icon_highlights = {
    file_icon = {
      tabline = function(self) return self.is_active or self.is_visible end,
      statusline = true,
    },
  },
  buf_matchers = {
    filetype = function(pattern_list, bufnr) return pattern_match(vim.bo[bufnr or 0].filetype, pattern_list) end,
    buftype = function(pattern_list, bufnr) return pattern_match(vim.bo[bufnr or 0].buftype, pattern_list) end,
    bufname = function(pattern_list, bufnr) return pattern_match(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr or 0), ":t"), pattern_list) end,
  },
}

--- Get the highlight background color of the lualine theme for the current colorscheme
-- @param  mode the neovim mode to get the color of
-- @param  fallback the color to fallback on if a lualine theme is not present
-- @return The background color of the lualine theme or the fallback parameter if one doesn't exist
local function lualine_mode(mode, fallback)
  local lualine_avail, lualine = pcall(require, "lualine.themes." .. (vim.g.colors_name or "default_theme"))
  local lualine_opts = lualine_avail and lualine[mode]
  return lualine_opts and type(lualine_opts.a) == "table" and lualine_opts.a.bg or fallback
end

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
  local HeirlineInactive = fignvim.ui.get_hlgroup("HeirlineInactive", { fg = nil }).fg or lualine_mode("inactive", C.grey_7)
  local HeirlineNormal = fignvim.ui.get_hlgroup("HeirlineNormal", { fg = nil }).fg or lualine_mode("normal", C.blue)
  local HeirlineInsert = fignvim.ui.get_hlgroup("HeirlineInsert", { fg = nil }).fg or lualine_mode("insert", C.green)
  local HeirlineVisual = fignvim.ui.get_hlgroup("HeirlineVisual", { fg = nil }).fg or lualine_mode("visual", C.purple)
  local HeirlineReplace = fignvim.ui.get_hlgroup("HeirlineReplace", { fg = nil }).fg or lualine_mode("replace", C.red_1)
  local HeirlineCommand = fignvim.ui.get_hlgroup("HeirlineCommand", { fg = nil }).fg or lualine_mode("command", C.yellow_1)
  local HeirlineTerminal = fignvim.ui.get_hlgroup("HeirlineTerminal", { fg = nil }).fg or lualine_mode("inactive", HeirlineInsert)

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

--- A helper function to get the type a tab or buffer is
-- @param self the self table from a heirline component function
-- @param prefix the prefix of the type, either "tab" or "buffer" (Default: "buffer")
-- @return the string of prefix with the type (i.e. "_active" or "_visible")
local function tab_type(self, prefix)
  local tab_type = ""
  if self.is_active then
    tab_type = "_active"
  elseif self.is_visible then
    tab_type = "_visible"
  end
  return (prefix or "buffer") .. tab_type
end

--- Merge the color and attributes from user settings for a given name
-- @param name string, the name of the element to get the attributes and colors for
-- @param include_bg boolean whether or not to include background color (Default: false)
-- @return a table of highlight information
-- @usage local heirline_component = { provider = "Example Provider", hl = astronvim.status.hl.get_attributes("treesitter") },
local function get_attributes(name, include_bg)
  local hl = status.env.attributes[name] or {}
  hl.fg = name .. "_fg"
  if include_bg then hl.bg = name .. "_bg" end
  return hl
end

--- Surround component with separator and color adjustment
-- @param separator the separator index to use in `astronvim.status.env.separators`
-- @param color the color to use as the separator foreground/component background
-- @param component the component to surround
-- @param condition the condition for displaying the surrounded component
-- @return the new surrounded component
local function surround(separator, color, component, condition)
  local function surround_color(self)
    local colors = type(color) == "function" and color(self) or color
    return type(colors) == "string" and { main = colors } or colors
  end

  separator = type(separator) == "string" and status.env.separators[separator] or separator
  local surrounded = { condition = condition }
  if separator[1] ~= "" then
    table.insert(surrounded, {
      provider = separator[1],
      hl = function(self)
        local s_color = surround_color(self)
        if s_color then return { fg = s_color.main, bg = s_color.left } end
      end,
    })
  end
  table.insert(surrounded, {
    hl = function(self)
      local s_color = surround_color(self)
      if s_color then return { bg = s_color.main } end
    end,
    fignvim.table.default_tbl({}, component),
  })
  if separator[2] ~= "" then
    table.insert(surrounded, {
      provider = separator[2],
      hl = function(self)
        local s_color = surround_color(self)
        if s_color then return { fg = s_color.main, bg = s_color.right } end
      end,
    })
  end
  return surrounded
end

--- A utility function to stylize a string with an icon from lspkind, separators, and left/right padding
-- @param str the string to stylize
-- @param opts options of `{ padding = { left = 0, right = 0 }, separator = { left = "|", right = "|" }, show_empty = false, icon = { kind = "NONE", padding = { left = 0, right = 0 } } }`
-- @return the stylized string
-- @usage local string = astronvim.status.utils.stylize("Hello", { padding = { left = 1, right = 1 }, icon = { kind = "String" } })
local function stylize(str, opts)
  opts = fignvim.table.default_tbl(opts, {
    padding = { left = 0, right = 0 },
    separator = { left = "", right = "" },
    show_empty = false,
    icon = { kind = "NONE", padding = { left = 0, right = 0 } },
  })
  local icon = fignvim.string.pad_string(fignvim.ui.get_icon(opts.icon.kind), opts.icon.padding)
  return str
      and (str ~= "" or opts.show_empty)
      and opts.separator.left .. fignvim.string.pad_string(icon .. str, opts.padding) .. opts.separator.right
    or ""
end

--- A provider function for showing the current filename
-- @param opts options for argument to fnamemodify to format filename and options passed to the stylize function
-- @return the function for outputting the filename
-- @usage local heirline_component = { provider = astronvim.status.provider.filename() }
-- @see astronvim.status.utils.stylize
local function filename(opts)
  opts = fignvim.table.default_tbl(opts, { fallback = "[No Name]", fname = function(nr) return vim.api.nvim_buf_get_name(nr) end, modify = ":t" })
  return function(self)
    local filename = vim.fn.fnamemodify(opts.fname(self and self.bufnr or 0), opts.modify)
    return stylize((filename == "" and opts.fallback or filename), opts)
  end
end

--- Make a list of buffers, rendering each buffer with the provided component
---@param component table
---@return table
local function make_buflist(component)
  local overflow_hl = astronvim.status.hl.get_attributes("buffer_overflow", true)
  return require("heirline.utils").make_buflist(
    surround(
      "tab",
      function(self)
        return {
          main = tab_type(self) .. "_bg",
          left = "tabline_bg",
          right = "tabline_bg",
        }
      end,
      { -- bufferlist
        init = function(self) self.tab_type = tab_type(self) end,
        on_click = { -- add clickable component to each buffer
          callback = function(_, minwid) vim.api.nvim_win_set_buf(0, minwid) end,
          minwid = function(self) return self.bufnr end,
          name = "heirline_tabline_buffer_callback",
        },
        { -- add buffer picker functionality to each buffer
          condition = function(self) return self._show_picker end,
          update = false,
          init = function(self)
            local bufname = astronvim.status.provider.filename({ fallback = "empty_file" })(self)
            local label = bufname:sub(1, 1)
            local i = 2
            while label ~= " " and self._picker_labels[label] do
              if i > #bufname then break end
              label = bufname:sub(i, i)
              i = i + 1
            end
            self._picker_labels[label] = self.bufnr
            self.label = label
          end,
          provider = function(self) return astronvim.status.provider.str({ str = self.label, padding = { left = 1, right = 1 } }) end,
          hl = astronvim.status.hl.get_attributes("buffer_picker"),
        },
        component, -- create buffer component
      },
      false -- disable surrounding
    ),
    { provider = astronvim.get_icon("ArrowLeft") .. " ", hl = overflow_hl },
    { provider = astronvim.get_icon("ArrowRight") .. " ", hl = overflow_hl },
    function() return vim.t.bufs end, -- use astronvim bufs variable
    false -- disable internal caching
  )
end
