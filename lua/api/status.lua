fignvim.status = {}

fignvim.status = { hl = {}, init = {}, provider = {}, condition = {}, component = {}, utils = {}, env = {} }
local devicons = fignvim.plug.load_module_file("nvim-web-devicons")

fignvim.status.env.modes = {
  ["n"] = { "NORMAL", "normal" },
  ["no"] = { "OP", "normal" },
  ["nov"] = { "OP", "normal" },
  ["noV"] = { "OP", "normal" },
  ["no"] = { "OP", "normal" },
  ["niI"] = { "NORMAL", "normal" },
  ["niR"] = { "NORMAL", "normal" },
  ["niV"] = { "NORMAL", "normal" },
  ["i"] = { "INSERT", "insert" },
  ["ic"] = { "INSERT", "insert" },
  ["ix"] = { "INSERT", "insert" },
  ["t"] = { "TERM", "insert" },
  ["nt"] = { "TERM", "insert" },
  ["v"] = { "VISUAL", "visual" },
  ["vs"] = { "VISUAL", "visual" },
  ["V"] = { "LINES", "visual" },
  ["Vs"] = { "LINES", "visual" },
  [""] = { "BLOCK", "visual" },
  ["s"] = { "BLOCK", "visual" },
  ["R"] = { "REPLACE", "replace" },
  ["Rc"] = { "REPLACE", "replace" },
  ["Rx"] = { "REPLACE", "replace" },
  ["Rv"] = { "V-REPLACE", "replace" },
  ["s"] = { "SELECT", "visual" },
  ["S"] = { "SELECT", "visual" },
  [""] = { "BLOCK", "visual" },
  ["c"] = { "COMMAND", "command" },
  ["cv"] = { "COMMAND", "command" },
  ["ce"] = { "COMMAND", "command" },
  ["r"] = { "PROMPT", "inactive" },
  ["rm"] = { "MORE", "inactive" },
  ["r?"] = { "CONFIRM", "inactive" },
  ["!"] = { "SHELL", "inactive" },
  ["null"] = { "null", "inactive" },
}

local function pattern_match(str, pattern_list)
  for _, pattern in ipairs(pattern_list) do
    if str:find(pattern) then
      return true
    end
  end
  return false
end

fignvim.status.env.buf_matchers = {
  filetype = function(pattern_list)
    return pattern_match(vim.bo.filetype, pattern_list)
  end,
  buftype = function(pattern_list)
    return pattern_match(vim.bo.buftype, pattern_list)
  end,
  bufname = function(pattern_list)
    return pattern_match(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t"), pattern_list)
  end,
}

fignvim.status.env.separators = {
  none = { "", "" },
  left = { "", "  " },
  right = { "  ", "" },
  center = { "  ", "  " },
  tab = { "", "" },
}

--- Get the highlight for the current mode
---@return table the highlight group for the current mode
---@usage local heirline_component = { provider = "Example Provider", hl = astronvim.status.hl.mode },
function fignvim.status.hl.mode()
  return { bg = fignvim.status.hl.mode_bg() }
end

--- Get the foreground color group for the current mode, good for usage with Heirline surround utility
---@return any the highlight group for the current mode foreground
---@usage local heirline_component = require("heirline.utils").surround({ "|", "|" }, astronvim.status.hl.mode_bg, heirline_component),
function fignvim.status.hl.mode_bg()
  return fignvim.status.env.modes[vim.fn.mode()][2]
end

--- Get the foreground color group for the current filetype
---@return table the highlight group for the current filetype foreground
---@usage local heirline_component = { provider = astronvim.status.provider.fileicon(), hl = astronvim.status.hl.filetype_color },
function fignvim.status.hl.filetype_color(self)
  if not devicons then
    return {}
  end
  local _, color = devicons.get_icon_color(
    vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self and self.bufnr or 0), ":t"),
    nil,
    { default = true }
  )
  return { fg = color }
end

--- An `init` function to build a set of children components for LSP breadcrumbs
---@param opts table Options for configuring the breadcrumbs (default: `{ separator = " > ", icon = { enabled = true, hl = false }, padding = { left = 0, right = 0 } }`)
-- @return The Heirline init function
-- @usage local heirline_component = { init = astronvim.status.init.breadcrumbs { padding = { left = 1 } } }
function fignvim.status.init.breadcrumbs(opts)
  local aerial = fignvim.plug.load_module_file("aerial")
  opts = fignvim.table.default_tbl(
    opts,
    { separator = " > ", icon = { enabled = true, hl = false }, padding = { left = 0, right = 0 } }
  )
  return function(self)
    local data = aerial and aerial.get_location(true) or {}
    local children = {}
    -- create a child for each level
    for i, d in ipairs(data) do
      local pos = fignvim.status.utils.encode_pos(d.lnum, d.col, self.winnr)
      local child = {
        { provider = string.gsub(d.name, "%%", "%%%%"):gsub("%s*->%s*", "") }, -- add symbol name
        on_click = { -- add on click function
          minwid = pos,
          callback = function(_, minwid)
            local lnum, col, winnr = fignvim.status.utils.decode_pos(minwid)
            vim.api.nvim_win_set_cursor(vim.fn.win_getid(winnr), { lnum, col })
          end,
          name = "heirline_breadcrumbs",
        },
      }
      if opts.icon.enabled then -- add icon and highlight if enabled
        table.insert(child, 1, {
          provider = string.format("%s ", d.icon),
          hl = opts.icon.hl and string.format("Aerial%sIcon", d.kind) or nil,
        })
      end
      if #data > 1 and i < #data then
        table.insert(child, { provider = opts.separator })
      end -- add a separator only if needed
      table.insert(children, child)
    end
    if opts.padding.left > 0 then -- add left padding
      table.insert(children, 1, { provider = fignvim.string.pad_string(" ", { left = opts.padding.left - 1 }) })
    end
    if opts.padding.right > 0 then -- add right padding
      table.insert(children, { provider = fignvim.string.pad_string(" ", { right = opts.padding.right - 1 }) })
    end
    -- instantiate the new child
    self[1] = self:new(children, 1)
  end
end

--- An `init` function to build multiple update events which is not supported yet by Heirline's update field
---@param opts table An array like table of autocmd events as either just a string or a table with custom patterns and callbacks.
---@return function The Heirline init function
---@usage local heirline_component = { init = astronvim.status.init.update_events { "BufEnter", { "User", pattern = "LspProgressUpdate" } } }
function fignvim.status.init.update_events(opts)
  return function(self)
    if not rawget(self, "once") then
      local clear_cache = function()
        self._win_cache = nil
      end
      for _, event in ipairs(opts) do
        local event_opts = { callback = clear_cache }
        if type(event) == "table" then
          event_opts.pattern = event.pattern
          event_opts.callback = event.callback or clear_cache
          event.pattern = nil
          event.callback = nil
        end
        vim.api.nvim_create_autocmd(event, event_opts)
      end
      self.once = true
    end
  end
end

--- A provider function for the fill string
---@return string The statusline string for filling the empty space
---@usage local heirline_component = { provider = astronvim.status.provider.fill }
function fignvim.status.provider.fill()
  return "%="
end

--- A provider function for showing if spellcheck is on
---@param opts table options passed to the stylize function
---@return function the function for outputting if spell is enabled
---@usage local heirline_component = { provider = fignvim.status.provider.spell() }
---@see fignvim.status.utils.stylize
function fignvim.status.provider.spell(opts)
  opts = fignvim.fn.table.default_tbl(opts, { str = "", icon = { kind = "Spellcheck" }, show_empty = true })
  return function()
    return fignvim.ui.stylize(vim.wo.spell and opts.str, opts)
  end
end

--- A provider function for showing if paste is enabled
---@param opts table options passed to the stylize function
---@return function the function for outputting if paste is enabled
---@usage local heirline_component = { provider = astronvim.status.provider.paste() }
function fignvim.status.provider.paste(opts)
  opts = fignvim.table.table.default_tbl(opts, { str = "", icon = { kind = "Paste" }, show_empty = true })
  return function()
    return fignvim.ui.stylize(vim.opt.paste:get() and opts.str, opts)
  end
end

--- A provider function for displaying if a macro is currently being recorded
---@param opts table a prefix before the recording register and options passed to the stylize function
---@return function a function that returns a string of the current recording status
---@usage local heirline_component = { provider = astronvim.status.provider.macro_recording() }
function fignvim.status.provider.macro_recording(opts)
  opts = fignvim.table.default_tbl(opts, { prefix = "@" })
  return function()
    local register = vim.fn.reg_recording()
    if register ~= "" then
      register = opts.prefix .. register
    end
    return fignvim.ui.stylize(register, opts)
  end
end

--- A provider function for showing the text of the current vim mode
---@param opts table options for padding the text and options passed to the stylize function
---@return function the function for displaying the text of the current vim mode
---@usage local heirline_component = { provider = astronvim.status.provider.mode_text() }
function fignvim.status.provider.mode_text(opts)
  local max_length = math.max(unpack(vim.tbl_map(function(str)
    return #str[1]
  end, vim.tbl_values(fignvim.status.env.modes))))
  return function()
    local text = fignvim.status.env.modes[vim.fn.mode()][1]
    if opts.pad_text then
      local padding = max_length - #text
      if opts.pad_text == "right" then
        text = string.rep(" ", padding) .. text
      elseif opts.pad_text == "left" then
        text = text .. string.rep(" ", padding)
      elseif opts.pad_text == "center" then
        text = string.rep(" ", math.floor(padding / 2)) .. text .. string.rep(" ", math.ceil(padding / 2))
      end
    end
    return fignvim.ui.stylize(text, opts)
  end
end

--- A provider function for showing the percentage of the current location in a document
---@param opts table options passed to the stylize function
---@return string | function the statusline string for displaying the percentage of current document location
---@usage local heirline_component = { provider = astronvim.status.provider.percentage() }
function fignvim.status.provider.percentage(opts)
  return function()
    local text = "%p%%"
    local current_line = vim.fn.line(".")
    if current_line == 1 then
      text = "Top"
    elseif current_line == vim.fn.line("$") then
      text = "Bot"
    end
    return fignvim.ui.stylize(text, opts)
  end
end

--- A provider function for showing the current line and character in a document
---@param opts table options for padding the line and character locations and options passed to the stylize function
---@return string the statusline string for showing location in document line_num:char_num
---@usage local heirline_component = { provider = astronvim.status.provider.ruler({ pad_ruler = { line = 3, char = 2 } }) }
function fignvim.status.provider.ruler(opts)
  opts = fignvim.table.default_tbl(opts, { pad_ruler = { line = 0, char = 0 } })
  return fignvim.ui.stylize(string.format("%%%dl:%%%dc", opts.pad_ruler.line, opts.pad_ruler.char), opts)
end

--- A provider function for showing the current location as a scrollbar
---@param opts table options passed to the stylize function
---@return function the function for outputting the scrollbar
---@usage local heirline_component = { provider = astronvim.status.provider.scrollbar() }
function fignvim.status.provider.scrollbar(opts)
  local sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
  return function()
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor((curr_line - 1) / lines * #sbar) + 1
    return fignvim.ui.stylize(string.rep(sbar[i], 2), opts)
  end
end

--- A provider to simply show a close button icon
---@param opts table options passed to the stylize function and the kind of icon to use
---@return string return the stylized icon
---@usage local heirline_component = { provider = astronvim.status.provider.close_button() }
function fignvim.status.provider.close_button(opts)
  opts = fignvim.table.default_tbl(opts, { kind = "BufferClose" })
  return fignvim.ui.stylize(fignvim.get_icon(opts.kind), opts)
end

--- A provider function for showing the current filetype
---@param opts table options passed to the stylize function
---@return function the function for outputting the filetype
---@usage local heirline_component = { provider = astronvim.status.provider.filetype() }
function fignvim.status.provider.filetype(opts)
  return function(self)
    local buffer = vim.bo[self and self.bufnr or 0]
    return fignvim.ui.stylize(string.lower(buffer.filetype), opts)
  end
end

--- A provider function for showing the current filename
---@param opts table options for argument to fnamemodify to format filename and options passed to the stylize function
---@return function the function for outputting the filename
---@usage local heirline_component = { provider = astronvim.status.provider.filename() }
function fignvim.status.provider.filename(opts)
  opts = fignvim.table.default_tbl(opts, {
    fname = function(nr)
      return vim.api.nvim_buf_get_name(nr)
    end,
    modify = ":t",
  })
  return function(self)
    local filename = vim.fn.fnamemodify(opts.fname(self and self.bufnr or 0), opts.modify)
    return fignvim.ui.stylize((filename == "" and "[No Name]" or filename), opts)
  end
end

--- Get a unique filepath between all buffers
---@param opts table options for function to get the buffer name, a buffer number, max length, and options passed to the stylize function
---@return function Function to return a path to file that uniquely identifies each buffer
---@usage local heirline_component = { provider = astronvim.status.provider.unique_path() }
function fignvim.status.provider.unique_path(opts)
  opts = fignvim.table.default_tbl(opts, {
    buf_name = function(bufnr)
      return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
    end,
    bufnr = 0,
    max_length = 16,
  })
  return function(self)
    opts.bufnr = self and self.bufnr or opts.bufnr
    local name = opts.buf_name(opts.bufnr)
    local unique_path = ""
    -- check for same buffer names under different dirs
    for _, value in ipairs(fignvim.status.utils.get_valid_buffers()) do
      if name == opts.buf_name(value) and value ~= opts.bufnr then
        local other = {}
        for match in (vim.api.nvim_buf_get_name(value) .. "/"):gmatch("(.-)" .. "/") do
          table.insert(other, match)
        end

        local current = {}
        for match in (vim.api.nvim_buf_get_name(opts.bufnr) .. "/"):gmatch("(.-)" .. "/") do
          table.insert(current, match)
        end

        unique_path = ""

        for i = #current - 1, 1, -1 do
          local value_current = current[i]
          local other_current = other[i]

          if value_current ~= other_current then
            unique_path = value_current .. "/"
            break
          end
        end
        break
      end
    end
    return fignvim.ui.stylize(
      (
        opts.max_length > 0
        and #unique_path > opts.max_length
        and string.sub(unique_path, 1, opts.max_length - 2) .. fignvim.ui.get_icon("Ellipsis") .. "/"
      ) or unique_path,
      opts
    )
  end
end

--- A provider function for showing if the current file is modifiable
---@param opts table options passed to the stylize function
---@return function the function for outputting the indicator if the file is modified
---@usage local heirline_component = { provider = fignvim.status.provider.file_modified() }
function fignvim.status.provider.file_modified(opts)
  opts = fignvim.table.default_tbl(opts, { str = "", icon = { kind = "FileModified" }, show_empty = true })
  return function(self)
    return fignvim.ui.stylize(fignvim.status.condition.file_modified((self or {}).bufnr) and opts.str, opts)
  end
end

--- A provider function for showing if the current file is read-only
---@param opts table options passed to the stylize function
---@return function the function for outputting the indicator if the file is read-only
---@usage local heirline_component = { provider = fignvim.status.provider.file_read_only() }
function fignvim.status.provider.file_read_only(opts)
  opts = fignvim.table.default_tbl(opts, { str = "", icon = { kind = "FileReadOnly" }, show_empty = true })
  return function(self)
    return fignvim.ui.stylize(fignvim.status.condition.file_read_only((self or {}).bufnr) and opts.str, opts)
  end
end

--- A provider function for showing the current filetype icon
---@param opts table options passed to the stylize function
---@return function | string the function for outputting the filetype icon
---@usage local heirline_component = { provider = fignvim.status.provider.file_icon() }
function fignvim.status.provider.file_icon(opts)
  if not devicons then
    return ""
  end
  return function(self)
    local ft_icon, _ = devicons.get_icon(
      vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self and self.bufnr or 0), ":t"),
      nil,
      { default = true }
    )
    return fignvim.ui.stylize(ft_icon, opts)
  end
end

--- A provider function for showing the current git branch
---@param opts table options passed to the stylize function
---@return function the function for outputting the git branch
---@usage local heirline_component = { provider = fignvim.status.provider.git_branch() }
function fignvim.status.provider.git_branch(opts)
  return function(self)
    return fignvim.ui.stylize(vim.b[self and self.bufnr or 0].gitsigns_head or "", opts)
  end
end

--- A provider function for showing the current git diff count of a specific type
---@param opts table options for type of git diff and options passed to the stylize function
---@return function | nil the function for outputting the git diff
---@usage local heirline_component = { provider = fignvim.status.provider.git_diff({ type = "added" }) }
function fignvim.status.provider.git_diff(opts)
  if not opts or not opts.type then
    return
  end
  return function(self)
    local status = vim.b[self and self.bufnr or 0].gitsigns_status_dict
    return fignvim.ui.stylize(
      status and status[opts.type] and status[opts.type] > 0 and tostring(status[opts.type]) or "",
      opts
    )
  end
end

--- A provider function for showing the current diagnostic count of a specific severity
---@param opts table options for severity of diagnostic and options passed to the stylize function
---@return function | nil The function for outputting the diagnostic count
---@usage local heirline_component = { provider = fignvim.status.provider.diagnostics({ severity = "ERROR" }) }
function fignvim.status.provider.diagnostics(opts)
  if not opts or not opts.severity then
    return
  end
  return function(self)
    local bufnr = self and self.bufnr or 0
    local count = #vim.diagnostic.get(bufnr, opts.severity and { severity = vim.diagnostic.severity[opts.severity] })
    return fignvim.ui.stylize(count ~= 0 and tostring(count) or "", opts)
  end
end

--- A provider function for showing the current progress of loading language servers
---@param opts table options passed to the stylize function
---@return function The function for outputting the LSP progress
---@usage local heirline_component = { provider = fignvim.status.provider.lsp_progress() }
function fignvim.status.provider.lsp_progress(opts)
  return function()
    local Lsp = vim.lsp.util.get_progress_messages()[1]
    return fignvim.ui.stylize(
      Lsp
          and string.format(
            " %%<%s %s %s (%s%%%%) ",
            fignvim.ui.get_icon("LSP" .. ((Lsp.percentage or 0) >= 70 and { "Loaded", "Loaded", "Loaded" } or {
              "Loading1",
              "Loading2",
              "Loading3",
            })[math.floor(vim.loop.hrtime() / 12e7) % 3 + 1]),
            Lsp.title or "",
            Lsp.message or "",
            Lsp.percentage or 0
          )
        or "",
      opts
    )
  end
end

--- A provider function for showing the connected LSP client names
---@param opts table options for explanding null_ls clients, max width percentage, and options passed to the stylize function
---@return function the function for outputting the LSP client names
---@usage local heirline_component = { provider = fignvim.status.provider.lsp_client_names({ expand_null_ls = true, truncate = 0.25 }) }
function fignvim.status.provider.lsp_client_names(opts)
  opts = fignvim.table.default_tbl(opts, { expand_null_ls = true, truncate = 0.25 })
  return function(self)
    local buf_client_names = {}
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = self and self.bufnr or 0 })) do
      if client.name == "null-ls" and opts.expand_null_ls then
        local null_ls_sources = {}
        for _, type in ipairs({ "FORMATTING", "DIAGNOSTICS" }) do
          for _, source in ipairs(fignvim.lsp.null_ls.sources(vim.bo.filetype, type)) do
            null_ls_sources[source] = true
          end
        end
        vim.list_extend(buf_client_names, vim.tbl_keys(null_ls_sources))
      else
        table.insert(buf_client_names, client.name)
      end
    end
    local str = table.concat(buf_client_names, ", ")
    if type(opts.truncate) == "number" then
      local max_width = math.floor(fignvim.status.utils.width() * opts.truncate)
      if #str > max_width then
        str = string.sub(str, 0, max_width) .. "…"
      end
    end
    return fignvim.ui.stylize(str, opts)
  end
end

--- A provider function for showing if treesitter is connected
---@param opts table options passed to the stylize function
---@return function The function for outputting TS if treesitter is connected
---@usage local heirline_component = { provider = fignvim.status.provider.treesitter_status() }
function fignvim.status.provider.treesitter_status(opts)
  return function()
    local ts = fignvim.plug.load_module_file("nvim-treesitter.parsers")
    return fignvim.ui.stylize((ts and ts.has_parser()) and "TS" or "", opts)
  end
end

--- A provider function for displaying a single string
---@param opts table options passed to the stylize function
---@return string the stylized statusline string
---@usage local heirline_component = { provider = fignvim.status.provider.str({ str = "Hello" }) }
function fignvim.status.provider.str(opts)
  opts = fignvim.table.default_tbl(opts, { str = " " })
  return fignvim.ui.stylize(opts.str, opts)
end

--- A condition function if the window is currently active
---@return boolean of whether or not the window is currently actie
---@usage local heirline_component = { provider = "Example Provider", condition = fignvim.status.condition.is_active }
function fignvim.status.condition.is_active()
  return vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin)
end

--- A condition function if the buffer filetype,buftype,bufname match a pattern
---@return boolean of wether or not LSP is attached
---@usage local heirline_component = { provider = "Example Provider", condition = function() return fignvim.status.condition.buffer_matches { buftype = { "terminal" } } end }
function fignvim.status.condition.buffer_matches(patterns)
  for kind, pattern_list in pairs(patterns) do
    if fignvim.status.env.buf_matchers[kind](pattern_list) then
      return true
    end
  end
  return false
end

--- A condition function if a macro is being recorded
---@return boolean of wether or not a macro is currently being recorded
---@usage local heirline_component = { provider = "Example Provider", condition = fignvim.status.condition.is_macro_recording }
function fignvim.status.condition.is_macro_recording()
  return vim.fn.reg_recording() ~= ""
end

--- A condition function if the current file is in a git repo
---@return boolean of wether or not the current file is in a git repo
---@usage local heirline_component = { provider = "Example Provider", condition = fignvim.status.condition.is_git_repo }
function fignvim.status.condition.is_git_repo()
  return vim.b.gitsigns_head or vim.b.gitsigns_status_dict
end

--- A condition function if there are any git changes
---@return boolean of wether or not there are any git changes
---@usage local heirline_component = { provider = "Example Provider", condition = fignvim.status.condition.git_changed }
function fignvim.status.condition.git_changed()
  local git_status = vim.b.gitsigns_status_dict
  return git_status and (git_status.added or 0) + (git_status.removed or 0) + (git_status.changed or 0) > 0
end

--- A condition function if the current buffer is modified
---@return boolean of wether or not the current buffer is modified
---@usage local heirline_component = { provider = "Example Provider", condition = fignvim.status.condition.file_modified }
function fignvim.status.condition.file_modified(bufnr)
  return vim.bo[bufnr or 0].modified
end

--- A condition function if the current buffer is read only
---@return boolean of wether or not the current buffer is read only or not modifiable
---@usage local heirline_component = { provider = "Example Provider", condition = fignvim.status.condition.file_read_only }
function fignvim.status.condition.file_read_only(bufnr)
  local buffer = vim.bo[bufnr or 0]
  return not buffer.modifiable or buffer.readonly
end

--- A condition function if the current file has any diagnostics
---@return boolean of wether or not the current file has any diagnostics
---@usage local heirline_component = { provider = "Example Provider", condition = fignvim.status.condition.has_diagnostics }
function fignvim.status.condition.has_diagnostics()
  return vim.g.status_diagnostics_enabled and #vim.diagnostic.get(0) > 0
end

--- A condition function if there is a defined filetype
---@return boolean of wether or not there is a filetype
---@usage local heirline_component = { provider = "Example Provider", condition = fignvim.status.condition.has_filetype }
function fignvim.status.condition.has_filetype()
  return vim.fn.empty(vim.fn.expand("%:t")) ~= 1 and vim.bo.filetype and vim.bo.filetype ~= ""
end

--- A condition function if Aerial is available
---@return boolean of wether or not aerial plugin is installed
---@usage local heirline_component = { provider = "Example Provider", condition = astronvim.status.condition.aerial_available }
function fignvim.status.condition.aerial_available()
  return fignvim.plug.is_available("aerial.nvim")
end

--- A condition function if LSP is attached
---@return boolean of wether or not LSP is attached
---@usage local heirline_component = { provider = "Example Provider", condition = fignvim.status.condition.lsp_attached }
function fignvim.status.condition.lsp_attached()
  return next(vim.lsp.buf_get_clients()) ~= nil
end

--- A condition function if treesitter is in use
---@return boolean of wether or not treesitter is active
---@usage local heirline_component = { provider = "Example Provider", condition = fignvim.status.condition.treesitter_available }
function fignvim.status.condition.treesitter_available()
  local ts = fignvim.plug.load_module_file("nvim-treesitter.parsers")
  return ts and ts.has_parser()
end

--- A Heirline component for filling in the empty space of the bar
---@return table The heirline component table
---@usage local heirline_component = fignvim.status.component.fill()
function fignvim.status.component.fill()
  return { provider = fignvim.status.provider.fill() }
end

--- A function to build a set of children components for an entire file information section
---@param opts? table options for configuring file_icon, filename, filetype, file_modified, file_read_only, and the overall padding
---@return table The Heirline component table
---@usage local heirline_component = fignvim.status.component.file_info()
function fignvim.status.component.file_info(opts)
  opts = fignvim.table.default_tbl(opts or {}, {
    file_icon = { highlight = true, padding = { left = 1, right = 1 } },
    filename = {},
    file_modified = { padding = { left = 1 } },
    file_read_only = { padding = { left = 1 } },
    surround = { separator = "left", color = "file_info_bg", condition = fignvim.status.condition.has_filetype },
    hl = { fg = "file_info_fg" },
  })
  for i, key in ipairs({
    "file_icon",
    "unique_path",
    "filename",
    "filetype",
    "file_modified",
    "file_read_only",
    "close_button",
  }) do
    opts[i] = opts[key]
        and {
          provider = key,
          opts = opts[key],
          hl = opts[key].highlight and fignvim.status.hl.filetype_color or opts[key].hl,
          on_click = opts[key].on_click,
        }
      or false
  end
  return fignvim.status.component.builder(opts)
end

--- A function to build a set of children components for an entire navigation section
---@param opts? table options for configuring ruler, percentage, scrollbar, and the overall padding
---@return table The Heirline component table
---@usage local heirline_component = fignvim.status.component.nav()
function fignvim.status.component.nav(opts)
  opts = fignvim.table.default_tbl(opts or {}, {
    ruler = {},
    percentage = { padding = { left = 1 } },
    scrollbar = { padding = { left = 1 }, hl = { fg = "scrollbar" } },
    surround = { separator = "right", color = "nav_bg" },
    hl = { fg = "nav_fg" },
    update = { "CursorMoved", "BufEnter" },
  })
  for i, key in ipairs({ "ruler", "percentage", "scrollbar" }) do
    opts[i] = opts[key] and { provider = key, opts = opts[key], hl = opts[key].hl } or false
  end
  return fignvim.status.component.builder(opts)
end

--- A function to build a set of children components for a macro recording section
---@param opts? table options for configuring macro recording and the overall padding
---@return table The Heirline component table
---@usage local heirline_component = fignvim.status.component.macro_recording()
function fignvim.status.component.macro_recording(opts)
  opts = fignvim.table.default_tbl(opts or {}, {
    macro_recording = { icon = { kind = "MacroRecording", padding = { right = 1 } } },
    surround = {
      separator = "center",
      color = "macro_recording_bg",
      condition = fignvim.status.condition.is_macro_recording,
    },
    hl = { fg = "macro_recording_fg", bold = true },
    update = { "RecordingEnter", "RecordingLeave" },
  })
  opts[1] = opts.macro_recording and { provider = "macro_recording", opts = opts.macro_recording } or false
  return fignvim.status.component.builder(opts)
end

--- A function to build a set of children components for a mode section
---@param opts? table options for configuring mode_text, paste, spell, and the overall padding
---@return table The Heirline component table
---@usage local heirline_component = fignvim.status.component.mode { mode_text = true }
function fignvim.status.component.mode(opts)
  opts = fignvim.table.default_tbl(opts or {}, {
    mode_text = false,
    paste = false,
    spell = false,
    surround = { separator = "left", color = fignvim.status.hl.mode_bg },
    hl = { fg = "bg" },
    update = "ModeChanged",
  })
  for i, key in ipairs({ "mode_text", "paste", "spell" }) do
    if key == "mode_text" and not opts[key] then
      opts[i] = { provider = "str", opts = { str = " " } }
    else
      opts[i] = opts[key] and { provider = key, opts = opts[key], hl = opts[key].hl } or false
    end
  end
  return fignvim.status.component.builder(opts)
end

--- A function to build a set of children components for an LSP breadcrumbs section
---@param opts table options for configuring breadcrumbs and the overall padding
---@return table The Heirline component table
---@usage local heirline_component = fignvim.status.component.breadcumbs()
function fignvim.status.component.breadcrumbs(opts)
  opts = fignvim.table.default_tbl(
    opts,
    { padding = { left = 1 }, condition = fignvim.status.condition.aerial_available, update = "CursorMoved" }
  )
  opts.init = fignvim.status.init.breadcrumbs(opts)
  return opts
end

--- A function to build a set of children components for a git branch section
---@param opts? table options for configuring git branch and the overall padding
---@return table The Heirline component table
---@usage local heirline_component = astronvim.status.component.git_branch()
function fignvim.status.component.git_branch(opts)
  opts = fignvim.table.default_tbl(opts or {}, {
    git_branch = { icon = { kind = "GitBranch", padding = { right = 1 } } },
    surround = { separator = "left", color = "git_branch_bg", condition = fignvim.status.condition.is_git_repo },
    hl = { fg = "git_branch_fg", bold = true },
    on_click = {
      name = "heirline_branch",
      callback = function()
        if fignvim.plug.is_available("telescope.nvim") then
          vim.defer_fn(function()
            require("telescope.builtin").git_branches()
          end, 100)
        end
      end,
    },
    update = { "User", pattern = "GitSignsUpdate" },
    init = fignvim.status.init.update_events({ "BufEnter" }),
  })
  opts[1] = opts.git_branch and { provider = "git_branch", opts = opts.git_branch } or false
  return fignvim.status.component.builder(opts)
end

--- A function to build a set of children components for a git difference section
---@param opts? table options for configuring git changes and the overall padding
---@return table The Heirline component table
---@usage local heirline_component = fignvim.status.component.git_diff()
function fignvim.status.component.git_diff(opts)
  opts = fignvim.table.default_tbl(opts or {}, {
    added = { icon = { kind = "GitAdd", padding = { left = 1, right = 1 } } },
    changed = { icon = { kind = "GitChange", padding = { left = 1, right = 1 } } },
    removed = { icon = { kind = "GitDelete", padding = { left = 1, right = 1 } } },
    hl = { fg = "git_diff_fg", bold = true },
    on_click = {
      name = "heirline_git",
      callback = function()
        if fignvim.plug.is_available("telescope.nvim") then
          vim.defer_fn(function()
            require("telescope.builtin").git_status()
          end, 100)
        end
      end,
    },
    surround = { separator = "left", color = "git_diff_bg", condition = fignvim.status.condition.git_changed },
    update = { "User", pattern = "GitSignsUpdate" },
    init = fignvim.status.init.update_events({ "BufEnter" }),
  })
  for i, kind in ipairs({ "added", "changed", "removed" }) do
    if type(opts[kind]) == "table" then
      opts[kind].type = kind
    end
    opts[i] = opts[kind] and { provider = "git_diff", opts = opts[kind], hl = { fg = "git_" .. kind } } or false
  end
  return fignvim.status.component.builder(opts)
end

--- A function to build a set of children components for a diagnostics section
---@param opts? table options for configuring diagnostic providers and the overall padding
---@return table The Heirline component table
---@usage local heirline_component = fignvim.status.component.diagnostics()
function fignvim.status.component.diagnostics(opts)
  opts = fignvim.table.default_tbl(opts or {}, {
    ERROR = { icon = { kind = "DiagnosticError", padding = { left = 1, right = 1 } } },
    WARN = { icon = { kind = "DiagnosticWarn", padding = { left = 1, right = 1 } } },
    INFO = { icon = { kind = "DiagnosticInfo", padding = { left = 1, right = 1 } } },
    HINT = { icon = { kind = "DiagnosticHint", padding = { left = 1, right = 1 } } },
    surround = { separator = "left", color = "diagnostics_bg", condition = fignvim.status.condition.has_diagnostics },
    hl = { fg = "diagnostics_fg" },
    on_click = {
      name = "heirline_diagnostic",
      callback = function()
        if fignvim.plug.is_available("telescope.nvim") then
          vim.defer_fn(function()
            require("telescope.builtin").diagnostics()
          end, 100)
        end
      end,
    },
    update = { "DiagnosticChanged", "BufEnter" },
  })
  for i, kind in ipairs({ "ERROR", "WARN", "INFO", "HINT" }) do
    if type(opts[kind]) == "table" then
      opts[kind].severity = kind
    end
    opts[i] = opts[kind] and { provider = "diagnostics", opts = opts[kind], hl = { fg = "diag_" .. kind } } or false
  end
  return fignvim.status.component.builder(opts)
end

--- A function to build a set of children components for a Treesitter section
---@param opts? table options for configuring diagnostic providers and the overall padding
---@return table The Heirline component table
---@usage local heirline_component = astronvim.status.component.treesitter()
function fignvim.status.component.treesitter(opts)
  opts = fignvim.table.default_tbl(opts or {}, {
    str = { str = "TS", icon = { kind = "ActiveTS" } },
    surround = {
      separator = "right",
      color = "treesitter_bg",
      condition = fignvim.status.condition.treesitter_available,
    },
    hl = { fg = "treesitter_fg" },
    update = { "OptionSet", pattern = "syntax" },
    init = fignvim.status.init.update_events({ "BufEnter" }),
  })
  opts[1] = opts.str and { provider = "str", opts = opts.str } or false
  return fignvim.status.component.builder(opts)
end

--- A function to build a set of children components for an LSP section
---@param opts? table options for configuring lsp progress and client_name providers and the overall padding
---@return table The Heirline component table
---@usage local heirline_component = fignvim.status.component.lsp()
function fignvim.status.component.lsp(opts)
  opts = fignvim.table.default_tbl(opts or {}, {
    lsp_progress = { str = "", padding = { right = 1 } },
    lsp_client_names = { str = "LSP", icon = { kind = "ActiveLSP", padding = { right = 2 } } },
    hl = { fg = "lsp_fg" },
    surround = { separator = "right", color = "lsp_bg", condition = fignvim.status.condition.lsp_attached },
    on_click = {
      name = "heirline_lsp",
      callback = function()
        vim.defer_fn(function()
          vim.cmd("LspInfo")
        end, 100)
      end,
    },
  })
  opts[1] = {}
  for i, provider in ipairs({ "lsp_progress", "lsp_client_names" }) do
    if type(opts[provider]) == "table" then
      local new_provider = opts[provider].str
          and fignvim.status.utils.make_flexible(
            i,
            { provider = fignvim.status.provider[provider](opts[provider]) },
            { provider = fignvim.status.provider.str(opts[provider]) }
          )
        or { provider = provider, opts = opts[provider] }
      if provider == "lsp_client_names" then
        new_provider.update = { "LspAttach", "LspDetach", "BufEnter" }
      end
      table.insert(opts[1], new_provider)
    end
  end
  return fignvim.status.component.builder(opts)
end

--- A general function to build a section of astronvim status providers with highlights, conditions, and section surrounding
---@param opts table a list of components to build into a section
---@return table The Heirline component table
---@usage local heirline_component = astronvim.status.components.builder({ { provider = "file_icon", opts = { padding = { right = 1 } } }, { provider = "filename" } })
function fignvim.status.component.builder(opts)
  opts = fignvim.table.default_tbl(opts, { padding = { left = 0, right = 0 } })
  local children = {}
  if opts.padding.left > 0 then -- add left padding
    table.insert(children, { provider = fignvim.string.pad_string(" ", { left = opts.padding.left - 1 }) })
  end
  for key, entry in pairs(opts) do
    if
      type(key) == "number"
      and type(entry) == "table"
      and fignvim.status.provider[entry.provider]
      and (entry.opts == nil or type(entry.opts) == "table")
    then
      entry.provider = fignvim.status.provider[entry.provider](entry.opts)
    end
    children[key] = entry
  end
  if opts.padding.right > 0 then -- add right padding
    table.insert(children, { provider = fignvim.string.pad_string(" ", { right = opts.padding.right - 1 }) })
  end
  return opts.surround
      and fignvim.status.utils.surround(opts.surround.separator, opts.surround.color, children, opts.surround.condition)
    or children
end

--- A utility function to get the width of the bar
---@param is_winbar? boolean true if you want the width of the winbar, false if you want the statusline width
---@return number The width of the specified bar
function fignvim.status.utils.width(is_winbar)
  return vim.o.laststatus == 3 and not is_winbar and vim.o.columns or vim.api.nvim_win_get_width(0)
end

local function insert(destination, ...)
  local new = fignvim.table.default_tbl({}, destination)
  for _, child in ipairs({ ... }) do
    table.insert(new, fignvim.table.default_tbl({}, child))
  end
  return new
end

--- Create a flexible statusline component
---@param priority number the priority of the element
---@return any the flexible component that switches between components to fit the width
function fignvim.status.utils.make_flexible(priority, ...)
  local new = insert({}, ...)
  new.static = { _priority = priority }
  new.init = function(self)
    if not vim.tbl_contains(self._flexible_components, self) then
      table.insert(self._flexible_components, self)
    end
    self:set_win_attr("_win_child_index", nil, 1)
    self.pick_child = { self:get_win_attr("_win_child_index") }
  end
  new.restrict = { _win_child_index = true }
  return new
end

--- Surround component with separator and color adjustment
---@param separator string | table the separator index to use in `fignvim.status.env.separators`
---@param color string | function the color to use as the separator foreground/component background
---@param component any the component to surround
---@param condition any the condition for displaying the surrounded component
---@return any the new surrounded component
function fignvim.status.utils.surround(separator, color, component, condition)
  local function surround_color(self)
    local colors = type(color) == "function" and color(self) or color
    return type(colors) == "string" and { main = colors } or colors
  end

  separator = type(separator) == "string" and fignvim.status.env.separators[separator] or separator
  local surrounded = { condition = condition }
  if separator[1] ~= "" then
    table.insert(surrounded, {
      provider = separator[1],
      hl = function(self)
        local s_color = surround_color(self)
        if s_color then
          return { fg = s_color.main, bg = s_color.left }
        end
      end,
    })
  end
  table.insert(surrounded, {
    hl = function(self)
      local s_color = surround_color(self)
      if s_color then
        return { bg = s_color.main }
      end
    end,
    fignvim.table.default_tbl({}, component),
  })
  if separator[2] ~= "" then
    table.insert(surrounded, {
      provider = separator[2],
      hl = function(self)
        local s_color = surround_color(self)
        if s_color then
          return { fg = s_color.main, bg = s_color.right }
        end
      end,
    })
  end
  return surrounded
end

--- Check if a buffer is valid
---@param bufnr number the buffer to check
---@return boolean True if the buffer is valid or false
function fignvim.status.utils.is_valid_buffer(bufnr)
  if not bufnr or bufnr < 1 then
    return false
  end
  return vim.bo[bufnr].buflisted and vim.api.nvim_buf_is_valid(bufnr)
end

--- Get all valid buffers
-- @return array-like table of valid buffer numbers
function fignvim.status.utils.get_valid_buffers()
  return vim.tbl_filter(fignvim.status.utils.is_valid_buffer, vim.api.nvim_list_bufs())
end

--- Encode a position to a single value that can be decoded later
---@param line number Line number of position
---@param col number Column number of position
---@param winnr number A window number
---@return any the encoded position
function fignvim.status.utils.encode_pos(line, col, winnr)
  return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr)
end

--- Decode a previously encoded position to it's sub parts
---@param c any the encoded position
---@return number,number,number line number, column number, window id
function fignvim.status.utils.decode_pos(c)
  return bit.rshift(c, 16), bit.band(bit.rshift(c, 6), 1023), bit.band(c, 63)
end

return fignvim.status
