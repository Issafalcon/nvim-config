fignvim.status = { hl = {}, init = {}, provider = {}, condition = {}, component = {}, utils = {}, env = {} }

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
  ["t"] = { "TERM", "terminal" },
  ["nt"] = { "TERM", "terminal" },
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

fignvim.status.env.separators = {
  none = { "", "" },
  left = { "", "  " },
  right = { "  ", "" },
  center = { "  ", "  " },
  tab = { "", " " },
}

fignvim.status.env.attributes = {
  buffer_active = { bold = true, italic = true },
  buffer_picker = { bold = true },
  macro_recording = { bold = true },
  git_branch = { bold = true },
  git_diff = { bold = true },
}

fignvim.status.env.icon_highlights = {
  file_icon = {
    tabline = function(self) return self.is_active or self.is_visible end,
    statusline = true,
  },
}

local function pattern_match(str, pattern_list)
  for _, pattern in ipairs(pattern_list) do
    if str:find(pattern) then return true end
  end
  return false
end

fignvim.status.env.buf_matchers = {
  filetype = function(pattern_list, bufnr) return pattern_match(vim.bo[bufnr or 0].filetype, pattern_list) end,
  buftype = function(pattern_list, bufnr) return pattern_match(vim.bo[bufnr or 0].buftype, pattern_list) end,
  bufname = function(pattern_list, bufnr) return pattern_match(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr or 0), ":t"), pattern_list) end,
}

--- Get the highlight background color of the lualine theme for the current colorscheme
-- @param  mode the neovim mode to get the color of
-- @param  fallback the color to fallback on if a lualine theme is not present
-- @return The background color of the lualine theme or the fallback parameter if one doesn't exist
function fignvim.status.hl.lualine_mode(mode, fallback)
  local lualine_avail, lualine = pcall(require, "lualine.themes." .. (vim.g.colors_name or "default_theme"))
  local lualine_opts = lualine_avail and lualine[mode]
  return lualine_opts and type(lualine_opts.a) == "table" and lualine_opts.a.bg or fallback
end

--- Get the highlight for the current mode
-- @return the highlight group for the current mode
-- @usage local heirline_component = { provider = "Example Provider", hl = fignvim.status.hl.mode },
function fignvim.status.hl.mode() return { bg = fignvim.status.hl.mode_bg() } end

--- Get the foreground color group for the current mode, good for usage with Heirline surround utility
-- @return the highlight group for the current mode foreground
-- @usage local heirline_component = require("heirline.utils").surround({ "|", "|" }, fignvim.status.hl.mode_bg, heirline_component),
function fignvim.status.hl.mode_bg() return fignvim.status.env.modes[vim.fn.mode()][2] end

--- Get the foreground color group for the current filetype
-- @return the highlight group for the current filetype foreground
-- @usage local heirline_component = { provider = fignvim.status.provider.fileicon(), hl = fignvim.status.hl.filetype_color },
function fignvim.status.hl.filetype_color(self)
  local devicons_avail, devicons = pcall(require, "nvim-web-devicons")
  if not devicons_avail then return {} end
  local _, color = devicons.get_icon_color(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self and self.bufnr or 0), ":t"), nil, { default = true })
  return { fg = color }
end

--- Merge the color and attributes from user settings for a given name
-- @param name string, the name of the element to get the attributes and colors for
-- @param include_bg boolean whether or not to include background color (Default: false)
-- @return a table of highlight information
-- @usage local heirline_component = { provider = "Example Provider", hl = fignvim.status.hl.get_attributes("treesitter") },
function fignvim.status.hl.get_attributes(name, include_bg)
  local hl = fignvim.status.env.attributes[name] or {}
  hl.fg = name .. "_fg"
  if include_bg then hl.bg = name .. "_bg" end
  return hl
end

--- Enable filetype color highlight if enabled in icon_highlights.file_icon options
-- @param name string of the icon_highlights.file_icon table element
-- @return function for setting hl property in a component
-- @usage local heirline_component = { provider = "Example Provider", hl = fignvim.status.hl.file_icon("winbar") },
function fignvim.status.hl.file_icon(name)
  return function(self)
    local hl_enabled = fignvim.status.env.icon_highlights.file_icon[name]
    if type(hl_enabled) == "function" then hl_enabled = hl_enabled(self) end
    if hl_enabled then return fignvim.status.hl.filetype_color(self) end
  end
end

--- An `init` function to build a set of children components for LSP breadcrumbs
-- @param opts options for configuring the breadcrumbs (default: `{ separator = " > ", icon = { enabled = true, hl = false }, padding = { left = 0, right = 0 } }`)
-- @return The Heirline init function
-- @usage local heirline_component = { init = fignvim.status.init.breadcrumbs { padding = { left = 1 } } }
function fignvim.status.init.breadcrumbs(opts)
  opts = fignvim.table.default_tbl(opts, {
    separator = " > ",
    icon = { enabled = true, hl = fignvim.status.env.icon_highlights.breadcrumbs },
    padding = { left = 0, right = 0 },
  })
  return function(self)
    local data = require("aerial").get_location(true) or {}
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
        local hl = opts.icon.hl
        if type(hl) == "function" then hl = hl(self) end
        table.insert(child, 1, {
          provider = string.format("%s ", d.icon),
          hl = hl and string.format("Aerial%sIcon", d.kind) or nil,
        })
      end
      if #data > 1 and i < #data then table.insert(child, { provider = opts.separator }) end -- add a separator only if needed
      table.insert(children, child)
    end
    if opts.padding.left > 0 then -- add left padding
      table.insert(children, 1, { provider = fignvim.pad_string(" ", { left = opts.padding.left - 1 }) })
    end
    if opts.padding.right > 0 then -- add right padding
      table.insert(children, { provider = fignvim.pad_string(" ", { right = opts.padding.right - 1 }) })
    end
    -- instantiate the new child
    self[1] = self:new(children, 1)
  end
end

--- An `init` function to build multiple update events which is not supported yet by Heirline's update field
-- @param opts an array like table of autocmd events as either just a string or a table with custom patterns and callbacks.
-- @return The Heirline init function
-- @usage local heirline_component = { init = fignvim.status.init.update_events { "BufEnter", { "User", pattern = "LspProgressUpdate" } } }
function fignvim.status.init.update_events(opts)
  return function(self)
    if not rawget(self, "once") then
      local clear_cache = function() self._win_cache = nil end
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
-- @return the statusline string for filling the empty space
-- @usage local heirline_component = { provider = fignvim.status.provider.fill }
function fignvim.status.provider.fill() return "%=" end

--- A provider function for the current tab numbre
-- @return the statusline function to return a string for a tab number
-- @usage local heirline_component = { provider = fignvim.status.provider.tabnr() }
function fignvim.status.provider.tabnr()
  return function(self) return (self and self.tabnr) and "%" .. self.tabnr .. "T " .. self.tabnr .. " %T" or "" end
end

--- A provider function for showing if spellcheck is on
-- @param opts options passed to the stylize function
-- @return the function for outputting if spell is enabled
-- @usage local heirline_component = { provider = fignvim.status.provider.spell() }
-- @see fignvim.status.utils.stylize
function fignvim.status.provider.spell(opts)
  opts = fignvim.table.default_tbl(opts, { str = "", icon = { kind = "Spellcheck" }, show_empty = true })
  return function() return fignvim.status.utils.stylize(vim.wo.spell and opts.str, opts) end
end

--- A provider function for showing if paste is enabled
-- @param opts options passed to the stylize function
-- @return the function for outputting if paste is enabled

-- @usage local heirline_component = { provider = fignvim.status.provider.paste() }
-- @see fignvim.status.utils.stylize
function fignvim.status.provider.paste(opts)
  opts = fignvim.table.default_tbl(opts, { str = "", icon = { kind = "Paste" }, show_empty = true })
  return function() return fignvim.status.utils.stylize(vim.opt.paste:get() and opts.str, opts) end
end

--- A provider function for displaying if a macro is currently being recorded
-- @param opts a prefix before the recording register and options passed to the stylize function
-- @return a function that returns a string of the current recording status
-- @usage local heirline_component = { provider = fignvim.status.provider.macro_recording() }
-- @see fignvim.status.utils.stylize
function fignvim.status.provider.macro_recording(opts)
  opts = fignvim.table.default_tbl(opts, { prefix = "@" })
  return function()
    local register = vim.fn.reg_recording()
    if register ~= "" then register = opts.prefix .. register end
    return fignvim.status.utils.stylize(register, opts)
  end
end

--- A provider function for displaying the current search count
-- @param opts options for `vim.fn.searchcount` and options passed to the stylize function
-- @return a function that returns a string of the current search location
-- @usage local heirline_component = { provider = fignvim.status.provider.search_count() }
-- @see fignvim.status.utils.stylize
function fignvim.status.provider.search_count(opts)
  local search_func = vim.tbl_isempty(opts or {}) and function() return vim.fn.searchcount() end or function() return vim.fn.searchcount(opts) end
  return function()
    local search_ok, search = pcall(search_func)
    if search_ok and type(search) == "table" and search.total then
      return fignvim.status.utils.stylize(
        string.format(
          "%s%d/%s%d",
          search.current > search.maxcount and ">" or "",
          math.min(search.current, search.maxcount),
          search.incomplete == 2 and ">" or "",
          math.min(search.total, search.maxcount)
        ),
        opts
      )
    end
  end
end

--- A provider function for showing the text of the current vim mode
-- @param opts options for padding the text and options passed to the stylize function
-- @return the function for displaying the text of the current vim mode
-- @usage local heirline_component = { provider = fignvim.status.provider.mode_text() }
-- @see fignvim.status.utils.stylize
function fignvim.status.provider.mode_text(opts)
  local max_length = math.max(unpack(vim.tbl_map(function(str) return #str[1] end, vim.tbl_values(fignvim.status.env.modes))))
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
    return fignvim.status.utils.stylize(text, opts)
  end
end

--- A provider function for showing the percentage of the current location in a document
-- @param opts options for Top/Bot text, fixed width, and options passed to the stylize function
-- @return the statusline string for displaying the percentage of current document location
-- @usage local heirline_component = { provider = fignvim.status.provider.percentage() }
-- @see fignvim.status.utils.stylize
function fignvim.status.provider.percentage(opts)
  opts = fignvim.table.default_tbl(opts, { fixed_width = false, edge_text = true })
  return function()
    local text = "%" .. (opts.fixed_width and "3" or "") .. "p%%"
    if opts.edge_text then
      local current_line = vim.fn.line(".")
      if current_line == 1 then
        text = (opts.fixed_width and " " or "") .. "Top"
      elseif current_line == vim.fn.line("$") then
        text = (opts.fixed_width and " " or "") .. "Bot"
      end
    end
    return fignvim.status.utils.stylize(text, opts)
  end
end

--- A provider function for showing the current line and character in a document
-- @param opts options for padding the line and character locations and options passed to the stylize function
-- @return the statusline string for showing location in document line_num:char_num
-- @usage local heirline_component = { provider = fignvim.status.provider.ruler({ pad_ruler = { line = 3, char = 2 } }) }
-- @see fignvim.status.utils.stylize
function fignvim.status.provider.ruler(opts)
  opts = fignvim.table.default_tbl(opts, { pad_ruler = { line = 0, char = 0 } })
  local padding_str = string.format("%%%dd:%%%dd", opts.pad_ruler.line, opts.pad_ruler.char)
  return function()
    local line = vim.fn.line(".")
    local char = vim.fn.virtcol(".")
    return fignvim.status.utils.stylize(string.format(padding_str, line, char), opts)
  end
end

--- A provider function for showing the current location as a scrollbar
-- @param opts options passed to the stylize function
-- @return the function for outputting the scrollbar
-- @usage local heirline_component = { provider = fignvim.status.provider.scrollbar() }
-- @see fignvim.status.utils.stylize
function fignvim.status.provider.scrollbar(opts)
  local sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
  return function()
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor((curr_line - 1) / lines * #sbar) + 1
    return fignvim.status.utils.stylize(string.rep(sbar[i], 2), opts)
  end
end

--- A provider to simply show a cloes button icon
-- @param opts options passed to the stylize function and the kind of icon to use
-- @return return the stylized icon
-- @usage local heirline_component = { provider = fignvim.status.provider.close_button() }
-- @see fignvim.status.utils.stylize
function fignvim.status.provider.close_button(opts)
  opts = fignvim.default_tbl(opts, { kind = "BufferClose" })
  return fignvim.status.utils.stylize(fignvim.get_icon(opts.kind), opts)
end

--- A provider function for showing the current filetype
-- @param opts options passed to the stylize function
-- @return the function for outputting the filetype
-- @usage local heirline_component = { provider = fignvim.status.provider.filetype() }
-- @see fignvim.status.utils.stylize
function fignvim.status.provider.filetype(opts)
  return function(self)
    local buffer = vim.bo[self and self.bufnr or 0]
    return fignvim.status.utils.stylize(string.lower(buffer.filetype), opts)
  end
end

--- A provider function for showing the current filename
-- @param opts options for argument to fnamemodify to format filename and options passed to the stylize function
-- @return the function for outputting the filename
-- @usage local heirline_component = { provider = fignvim.status.provider.filename() }
-- @see fignvim.status.utils.stylize
function fignvim.status.provider.filename(opts)
  opts = fignvim.table.default_tbl(opts, { fallback = "[No Name]", fname = function(nr) return vim.api.nvim_buf_get_name(nr) end, modify = ":t" })
  return function(self)
    local filename = vim.fn.fnamemodify(opts.fname(self and self.bufnr or 0), opts.modify)
    return fignvim.status.utils.stylize((filename == "" and opts.fallback or filename), opts)
  end
end

--- Get a unique filepath between all buffers
-- @param opts options for function to get the buffer name, a buffer number, max length, and options passed to the stylize function
-- @return path to file that uniquely identifies each buffer
-- @usage local heirline_component = { provider = fignvim.status.provider.unique_path() }
-- @see fignvim.status.utils.stylize
function fignvim.status.provider.unique_path(opts)
  opts = fignvim.table.default_tbl(opts, {
    buf_name = function(bufnr) return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t") end,
    bufnr = 0,
    max_length = 16,
  })
  return function(self)
    opts.bufnr = self and self.bufnr or opts.bufnr
    local name = opts.buf_name(opts.bufnr)
    local unique_path = ""
    -- check for same buffer names under different dirs
    -- TODO v3: remove get_valid_buffers
    for _, value in ipairs(vim.g.heirline_bufferline and vim.t.bufs or fignvim.status.utils.get_valid_buffers()) do
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
    return fignvim.status.utils.stylize(
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
-- @param opts options passed to the stylize function
-- @return the function for outputting the indicator if the file is modified
-- @usage local heirline_component = { provider = fignvim.status.provider.file_modified() }
-- @see fignvim.status.utils.stylize
function fignvim.status.provider.file_modified(opts)
  opts = fignvim.table.default_tbl(opts, { str = "", icon = { kind = "FileModified" }, show_empty = true })
  return function(self) return fignvim.status.utils.stylize(fignvim.status.condition.file_modified((self or {}).bufnr) and opts.str, opts) end
end

--- A provider function for showing if the current file is read-only
-- @param opts options passed to the stylize function
-- @return the function for outputting the indicator if the file is read-only
-- @usage local heirline_component = { provider = fignvim.status.provider.file_read_only() }
-- @see fignvim.status.utils.stylize
function fignvim.status.provider.file_read_only(opts)
  opts = fignvim.table.default_tbl(opts, { str = "", icon = { kind = "FileReadOnly" }, show_empty = true })
  return function(self) return fignvim.status.utils.stylize(fignvim.status.condition.file_read_only((self or {}).bufnr) and opts.str, opts) end
end

--- A provider function for showing the current filetype icon
-- @param opts options passed to the stylize function
-- @return the function for outputting the filetype icon
-- @usage local heirline_component = { provider = fignvim.status.provider.file_icon() }
-- @see fignvim.status.utils.stylize
function fignvim.status.provider.file_icon(opts)
  return function(self)
    local devicons_avail, devicons = pcall(require, "nvim-web-devicons")
    if not devicons_avail then return "" end
    local ft_icon, _ = devicons.get_icon(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self and self.bufnr or 0), ":t"), nil, { default = true })
    return fignvim.status.utils.stylize(ft_icon, opts)
  end
end

--- A provider function for showing the current git branch
-- @param opts options passed to the stylize function
-- @return the function for outputting the git branch
-- @usage local heirline_component = { provider = fignvim.status.provider.git_branch() }
-- @see fignvim.status.utils.stylize
function fignvim.status.provider.git_branch(opts)
  return function(self) return fignvim.status.utils.stylize(vim.b[self and self.bufnr or 0].gitsigns_head or "", opts) end
end

--- A provider function for showing the current git diff count of a specific type
-- @param opts options for type of git diff and options passed to the stylize function
-- @return the function for outputting the git diff
-- @usage local heirline_component = { provider = fignvim.status.provider.git_diff({ type = "added" }) }
-- @see fignvim.status.utils.stylize
function fignvim.status.provider.git_diff(opts)
  if not opts or not opts.type then return end
  return function(self)
    local status = vim.b[self and self.bufnr or 0].gitsigns_status_dict
    return fignvim.status.utils.stylize(status and status[opts.type] and status[opts.type] > 0 and tostring(status[opts.type]) or "", opts)
  end
end

--- A provider function for showing the current diagnostic count of a specific severity
-- @param opts options for severity of diagnostic and options passed to the stylize function
-- @return the function for outputting the diagnostic count
-- @usage local heirline_component = { provider = fignvim.status.provider.diagnostics({ severity = "ERROR" }) }
-- @see fignvim.status.utils.stylize
function fignvim.status.provider.diagnostics(opts)
  if not opts or not opts.severity then return end
  return function(self)
    local bufnr = self and self.bufnr or 0
    local count = #vim.diagnostic.get(bufnr, opts.severity and { severity = vim.diagnostic.severity[opts.severity] })
    return fignvim.status.utils.stylize(count ~= 0 and tostring(count) or "", opts)
  end
end

--- A provider function for showing the current progress of loading language servers
-- @param opts options passed to the stylize function
-- @return the function for outputting the LSP progress
-- @usage local heirline_component = { provider = fignvim.status.provider.lsp_progress() }
-- @see fignvim.status.utils.stylize
function fignvim.status.provider.lsp_progress(opts)
  return function()
    local Lsp = vim.lsp.util.get_progress_messages()[1]
    local function escape(str) return string.gsub(str, "%%2F", "/") end
    return fignvim.status.utils.stylize(
      Lsp
          and string.format(
            " %%<%s %s %s (%s%%%%) ",
            fignvim.get_icon("LSP" .. ((Lsp.percentage or 0) >= 70 and { "Loaded", "Loaded", "Loaded" } or {
              "Loading1",
              "Loading2",
              "Loading3",
            })[math.floor(vim.loop.hrtime() / 12e7) % 3 + 1]),
            Lsp.title and escape(Lsp.title) or "",
            Lsp.message and escape(Lsp.message) or "",
            Lsp.percentage or 0
          )
        or "",
      opts
    )
  end
end

--- A provider function for showing the connected LSP client names
-- @param opts options for explanding null_ls clients, max width percentage, and options passed to the stylize function
-- @return the function for outputting the LSP client names
-- @usage local heirline_component = { provider = fignvim.status.provider.lsp_client_names({ expand_null_ls = true, truncate = 0.25 }) }
-- @see fignvim.status.utils.stylize
function fignvim.status.provider.lsp_client_names(opts)
  opts = fignvim.table.default_tbl(opts, { expand_null_ls = true, truncate = 0.25 })
  return function(self)
    local buf_client_names = {}
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = self and self.bufnr or 0 })) do
      if client.name == "null-ls" and opts.expand_null_ls then
        local null_ls_sources = {}
        for _, type in ipairs({ "FORMATTING", "DIAGNOSTICS" }) do
          for _, source in ipairs(fignvim.null_ls_sources(vim.bo.filetype, type)) do
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
      if #str > max_width then str = string.sub(str, 0, max_width) .. "…" end
    end
    return fignvim.status.utils.stylize(str, opts)
  end
end

--- A provider function for showing if treesitter is connected
-- @param opts options passed to the stylize function
-- @return the function for outputting TS if treesitter is connected
-- @usage local heirline_component = { provider = fignvim.status.provider.treesitter_status() }
-- @see fignvim.status.utils.stylize
function fignvim.status.provider.treesitter_status(opts)
  return function() return fignvim.status.utils.stylize(require("nvim-treesitter.parser").has_parser() and "TS" or "", opts) end
end

--- A provider function for displaying a single string
-- @param opts options passed to the stylize function
-- @return the stylized statusline string
-- @usage local heirline_component = { provider = fignvim.status.provider.str({ str = "Hello" }) }
-- @see fignvim.status.utils.stylize
function fignvim.status.provider.str(opts)
  opts = fignvim.table.default_tbl(opts, { str = " " })
  return fignvim.status.utils.stylize(opts.str, opts)
end

--- A condition function if the window is currently active
-- @return boolean of wether or not the window is currently actie
-- @usage local heirline_component = { provider = "Example Provider", condition = fignvim.status.condition.is_active }
function fignvim.status.condition.is_active() return vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin) end

--- A condition function if the buffer filetype,buftype,bufname match a pattern
-- @param patterns the table of patterns to match
-- @param bufnr number of the buffer to match (Default: 0 [current])
-- @return boolean of wether or not LSP is attached
-- @usage local heirline_component = { provider = "Example Provider", condition = function() return fignvim.status.condition.buffer_matches { buftype = { "terminal" } } end }
function fignvim.status.condition.buffer_matches(patterns, bufnr)
  for kind, pattern_list in pairs(patterns) do
    if fignvim.status.env.buf_matchers[kind](pattern_list, bufnr) then return true end
  end
  return false
end

--- A condition function if a macro is being recorded
-- @return boolean of wether or not a macro is currently being recorded
-- @usage local heirline_component = { provider = "Example Provider", condition = fignvim.status.condition.is_macro_recording }
function fignvim.status.condition.is_macro_recording() return vim.fn.reg_recording() ~= "" end

--- A condition function if search is visible
-- @return boolean of wether or not searching is currently visible
-- @usage local heirline_component = { provider = "Example Provider", condition = fignvim.status.condition.is_hlsearch }
function fignvim.status.condition.is_hlsearch() return vim.v.hlsearch ~= 0 end

--- A condition function if the current file is in a git repo
-- @param bufnr a buffer number to check the condition for, a table with bufnr property, or nil to get the current buffer
-- @return boolean of wether or not the current file is in a git repo
-- @usage local heirline_component = { provider = "Example Provider", condition = fignvim.status.condition.is_git_repo }
function fignvim.status.condition.is_git_repo(bufnr)
  if type(bufnr) == "table" then bufnr = bufnr.bufnr end
  return vim.b[bufnr or 0].gitsigns_head or vim.b[bufnr or 0].gitsigns_status_dict
end

--- A condition function if there are any git changes
-- @param bufnr a buffer number to check the condition for, a table with bufnr property, or nil to get the current buffer
-- @return boolean of wether or not there are any git changes
-- @usage local heirline_component = { provider = "Example Provider", condition = fignvim.status.condition.git_changed }
function fignvim.status.condition.git_changed(bufnr)
  if type(bufnr) == "table" then bufnr = bufnr.bufnr end
  local git_status = vim.b[bufnr or 0].gitsigns_status_dict
  return git_status and (git_status.added or 0) + (git_status.removed or 0) + (git_status.changed or 0) > 0
end

--- A condition function if the current buffer is modified
-- @param bufnr a buffer number to check the condition for, a table with bufnr property, or nil to get the current buffer
-- @return boolean of wether or not the current buffer is modified
-- @usage local heirline_component = { provider = "Example Provider", condition = fignvim.status.condition.file_modified }
function fignvim.status.condition.file_modified(bufnr)
  if type(bufnr) == "table" then bufnr = bufnr.bufnr end
  return vim.bo[bufnr or 0].modified
end

--- A condition function if the current buffer is read only
-- @param bufnr a buffer number to check the condition for, a table with bufnr property, or nil to get the current buffer
-- @return boolean of wether or not the current buffer is read only or not modifiable
-- @usage local heirline_component = { provider = "Example Provider", condition = fignvim.status.condition.file_read_only }
function fignvim.status.condition.file_read_only(bufnr)
  if type(bufnr) == "table" then bufnr = bufnr.bufnr end
  local buffer = vim.bo[bufnr or 0]
  return not buffer.modifiable or buffer.readonly
end

--- A condition function if the current file has any diagnostics
-- @param bufnr a buffer number to check the condition for, a table with bufnr property, or nil to get the current buffer
-- @return boolean of wether or not the current file has any diagnostics
-- @usage local heirline_component = { provider = "Example Provider", condition = fignvim.status.condition.has_diagnostics }
function fignvim.status.condition.has_diagnostics(bufnr)
  if type(bufnr) == "table" then bufnr = bufnr.bufnr end
  return vim.g.status_diagnostics_enabled and #vim.diagnostic.get(bufnr or 0) > 0
end

--- A condition function if there is a defined filetype
-- @param bufnr a buffer number to check the condition for, a table with bufnr property, or nil to get the current buffer
-- @return boolean of wether or not there is a filetype
-- @usage local heirline_component = { provider = "Example Provider", condition = fignvim.status.condition.has_filetype }
function fignvim.status.condition.has_filetype(bufnr)
  if type(bufnr) == "table" then bufnr = bufnr.bufnr end
  return vim.fn.empty(vim.fn.expand("%:t")) ~= 1 and vim.bo[bufnr or 0].filetype and vim.bo[bufnr or 0].filetype ~= ""
end

--- A condition function if Aerial is available
-- @return boolean of wether or not aerial plugin is installed
-- @usage local heirline_component = { provider = "Example Provider", condition = fignvim.status.condition.aerial_available }
-- function fignvim.status.condition.aerial_available() return fignvim.is_available "aerial.nvim" end
function fignvim.status.condition.aerial_available()
  local aerial_ok, _ = pcall(require, "aerial")
  return aerial_ok
end

--- A condition function if LSP is attached
-- @param bufnr a buffer number to check the condition for, a table with bufnr property, or nil to get the current buffer
-- @return boolean of wether or not LSP is attached
-- @usage local heirline_component = { provider = "Example Provider", condition = fignvim.status.condition.lsp_attached }
function fignvim.status.condition.lsp_attached(bufnr)
  if type(bufnr) == "table" then bufnr = bufnr.bufnr end
  return next(vim.lsp.get_active_clients({ bufnr = bufnr or 0 })) ~= nil
end

--- A condition function if treesitter is in use
-- @param bufnr a buffer number to check the condition for, a table with bufnr property, or nil to get the current buffer
-- @return boolean of wether or not treesitter is active
-- @usage local heirline_component = { provider = "Example Provider", condition = fignvim.status.condition.treesitter_available }
function fignvim.status.condition.treesitter_available(bufnr)
  local ts_ok, _ = pcall(require, "nvim-treesitter")
  if not ts_ok then return false end
  if type(bufnr) == "table" then bufnr = bufnr.bufnr end
  local parsers = require("nvim-treesitter.parsers")
  return parsers.has_parser(parsers.get_buf_lang(bufnr or vim.api.nvim_get_current_buf()))
end

--- A utility function to stylize a string with an icon from lspkind, separators, and left/right padding
-- @param str the string to stylize
-- @param opts options of `{ padding = { left = 0, right = 0 }, separator = { left = "|", right = "|" }, show_empty = false, icon = { kind = "NONE", padding = { left = 0, right = 0 } } }`
-- @return the stylized string
-- @usage local string = fignvim.status.utils.stylize("Hello", { padding = { left = 1, right = 1 }, icon = { kind = "String" } })
function fignvim.status.utils.stylize(str, opts)
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

--- A Heirline component for filling in the empty space of the bar
-- @param opts options for configuring the other fields of the heirline component
-- @return The heirline component table
-- @usage local heirline_component = fignvim.status.component.fill()
function fignvim.status.component.fill(opts) return fignvim.table.default_tbl(opts, { provider = fignvim.status.provider.fill() }) end

--- A function to build a set of children components for an entire file information section
-- @param opts options for configuring file_icon, filename, filetype, file_modified, file_read_only, and the overall padding
-- @return The Heirline component table
-- @usage local heirline_component = fignvim.status.component.file_info()
function fignvim.status.component.file_info(opts)
  opts = fignvim.table.default_tbl(opts, {
    file_icon = {
      hl = fignvim.status.hl.file_icon("statusline"),
      padding = { left = 1, right = 1 },
    }, -- TODO: REWORK THIS
    filename = {},
    file_modified = { padding = { left = 1 } },
    file_read_only = { padding = { left = 1 } },
    surround = { separator = "left", color = "file_info_bg", condition = fignvim.status.condition.has_filetype },
    hl = fignvim.status.hl.get_attributes("file_info"),
  })
  return fignvim.status.component.builder(fignvim.status.utils.setup_providers(opts, {
    "file_icon",
    "unique_path",
    "filename",
    "filetype",
    "file_modified",
    "file_read_only",
    "close_button",
  }))
end

--- A function with different file_info defaults specifically for use in the tabline
-- @param opts options for configuring file_icon, filename, filetype, file_modified, file_read_only, and the overall padding
-- @return The Heirline component table
-- @usage local heirline_component = fignvim.status.component.tabline_file_info()
function fignvim.status.component.tabline_file_info(opts)
  return fignvim.status.component.file_info(fignvim.default_tbl(opts, {
    file_icon = {
      condition = function(self) return not self._show_picker end,
      hl = fignvim.status.hl.file_icon("tabline"),
    },
    unique_path = {
      hl = function(self) return fignvim.status.hl.get_attributes(self.tab_type .. "_path") end,
    },
    close_button = {
      hl = function(self) return fignvim.status.hl.get_attributes(self.tab_type .. "_close") end,
      padding = { left = 1, right = 1 },
      on_click = {
        callback = function(_, minwid) fignvim.close_buf(minwid) end,
        minwid = function(self) return self.bufnr end,
        name = "heirline_tabline_close_buffer_callback",
      },
    },
    padding = { left = 1, right = 1 },
    hl = function(self)
      local tab_type = self.tab_type
      if self._show_picker and self.tab_type ~= "buffer_active" then tab_type = "buffer_visible" end
      return fignvim.status.hl.get_attributes(tab_type)
    end,
    surround = false,
  }))
end

--- A function to build a set of children components for an entire navigation section
-- @param opts options for configuring ruler, percentage, scrollbar, and the overall padding
-- @return The Heirline component table
-- @usage local heirline_component = fignvim.status.component.nav()
function fignvim.status.component.nav(opts)
  opts = fignvim.table.default_tbl(opts, {
    ruler = {},
    percentage = { padding = { left = 1 } },
    scrollbar = { padding = { left = 1 }, hl = { fg = "scrollbar" } },
    surround = { separator = "right", color = "nav_bg" },
    hl = fignvim.status.hl.get_attributes("nav"),
    update = { "CursorMoved", "BufEnter" },
  })
  return fignvim.status.component.builder(fignvim.status.utils.setup_providers(opts, { "ruler", "percentage", "scrollbar" }))
end

--- A function to build a set of children components for a macro recording section
-- @param opts options for configuring macro recording and the overall padding
-- @return The Heirline component table
-- @usage local heirline_component = fignvim.status.component.macro_recording()
-- TODO: deprecate on next major version release
function fignvim.status.component.macro_recording(opts)
  opts = fignvim.table.default_tbl(opts, {
    macro_recording = { icon = { kind = "MacroRecording", padding = { right = 1 } } },
    surround = {
      separator = "center",
      color = "macro_recording_bg",
      condition = fignvim.status.condition.is_macro_recording,
    },
    hl = fignvim.status.hl.get_attributes("macro_recording"),
    update = { "RecordingEnter", "RecordingLeave" },
  })
  return fignvim.status.component.builder(fignvim.status.utils.setup_providers(opts, { "macro_recording" }))
end

--- A function to build a set of children components for information shown in the cmdline
-- @param opts options for configuring macro recording, search count, and the overall padding
-- @return The Heirline component table
-- @usage local heirline_component = fignvim.status.component.cmd_info()
function fignvim.status.component.cmd_info(opts)
  opts = fignvim.table.default_tbl(opts, {
    macro_recording = {
      icon = { kind = "MacroRecording", padding = { right = 1 } },
      condition = fignvim.status.condition.is_macro_recording,
      update = { "RecordingEnter", "RecordingLeave" },
    },
    search_count = {
      icon = { kind = "Search", padding = { right = 1 } },
      padding = { left = 1 },
      condition = fignvim.status.condition.is_hlsearch,
    },
    surround = {
      separator = "center",
      color = "cmd_info_bg",
      condition = function() return fignvim.status.condition.is_hlsearch() or fignvim.status.condition.is_macro_recording() end,
    },
    condition = function() return vim.opt.cmdheight:get() == 0 end,
    hl = fignvim.status.hl.get_attributes("cmd_info"),
  })
  return fignvim.status.component.builder(fignvim.status.utils.setup_providers(opts, { "macro_recording", "search_count" }))
end

--- A function to build a set of children components for a mode section
-- @param opts options for configuring mode_text, paste, spell, and the overall padding
-- @return The Heirline component table
-- @usage local heirline_component = fignvim.status.component.mode { mode_text = true }
function fignvim.status.component.mode(opts)
  opts = fignvim.default_tbl(opts, {
    mode_text = false,
    paste = false,
    spell = false,
    surround = { separator = "left", color = fignvim.status.hl.mode_bg },
    hl = fignvim.status.hl.get_attributes("mode"),
    update = "ModeChanged",
  })
  if not opts["mode_text"] then opts.str = { str = " " } end
  return fignvim.status.component.builder(fignvim.status.utils.setup_providers(opts, { "mode_text", "str", "paste", "spell" }))
end

--- A function to build a set of children components for an LSP breadcrumbs section
-- @param opts options for configuring breadcrumbs and the overall padding
-- @return The Heirline component table
-- @usage local heirline_component = fignvim.status.component.breadcumbs()
function fignvim.status.component.breadcrumbs(opts)
  opts = fignvim.table.default_tbl(opts, { padding = { left = 1 }, condition = fignvim.status.condition.aerial_available, update = "CursorMoved" })
  opts.init = fignvim.status.init.breadcrumbs(opts)
  return opts
end

--- A function to build a set of children components for a git branch section
-- @param opts options for configuring git branch and the overall padding
-- @return The Heirline component table
-- @usage local heirline_component = fignvim.status.component.git_branch()
function fignvim.status.component.git_branch(opts)
  opts = fignvim.table.default_tbl(opts, {
    git_branch = { icon = { kind = "GitBranch", padding = { right = 1 } } },
    surround = { separator = "left", color = "git_branch_bg", condition = fignvim.status.condition.is_git_repo },
    hl = fignvim.status.hl.get_attributes("git_branch"),
    on_click = {
      name = "heirline_branch",
      callback = function()
        local telescope_ok, telescope_builtin = pcall(require, "telescope.builtin")
        if telescope_ok then vim.defer_fn(telescope_builtin.git_branches(), 100) end
      end,
    },
    update = { "User", pattern = "GitSignsUpdate" },
    init = fignvim.status.init.update_events({ "BufEnter" }),
  })
  return fignvim.status.component.builder(fignvim.status.utils.setup_providers(opts, { "git_branch" }))
end

--- A function to build a set of children components for a git difference section
-- @param opts options for configuring git changes and the overall padding
-- @return The Heirline component table
-- @usage local heirline_component = fignvim.status.component.git_diff()
function fignvim.status.component.git_diff(opts)
  opts = fignvim.table.default_tbl(opts, {
    added = { icon = { kind = "GitAdd", padding = { left = 1, right = 1 } } },
    changed = { icon = { kind = "GitChange", padding = { left = 1, right = 1 } } },
    removed = { icon = { kind = "GitDelete", padding = { left = 1, right = 1 } } },
    hl = fignvim.status.hl.get_attributes("git_diff"),
    on_click = {
      name = "heirline_git",
      callback = function()
        local telescope_ok, telescope_builtin = pcall(require, "telescope.builtin")
        if telescope_ok then vim.defer_fn(telescope_builtin.git_status(), 100) end
      end,
    },
    surround = { separator = "left", color = "git_diff_bg", condition = fignvim.status.condition.git_changed },
    update = { "User", pattern = "GitSignsUpdate" },
    init = fignvim.status.init.update_events({ "BufEnter" }),
  })
  return fignvim.status.component.builder(fignvim.status.utils.setup_providers(opts, { "added", "changed", "removed" }, function(p_opts, provider)
    local out = fignvim.status.utils.build_provider(p_opts, provider)
    if out then
      out.provider = "git_diff"
      out.opts.type = provider
      if out.hl == nil then out.hl = { fg = "git_" .. provider } end
    end
    return out
  end))
end

--- A function to build a set of children components for a diagnostics section
-- @param opts options for configuring diagnostic providers and the overall padding
-- @return The Heirline component table
-- @usage local heirline_component = fignvim.status.component.diagnostics()
function fignvim.status.component.diagnostics(opts)
  opts = fignvim.table.default_tbl(opts, {
    ERROR = { icon = { kind = "DiagnosticError", padding = { left = 1, right = 1 } } },
    WARN = { icon = { kind = "DiagnosticWarn", padding = { left = 1, right = 1 } } },
    INFO = { icon = { kind = "DiagnosticInfo", padding = { left = 1, right = 1 } } },
    HINT = { icon = { kind = "DiagnosticHint", padding = { left = 1, right = 1 } } },
    surround = { separator = "left", color = "diagnostics_bg", condition = fignvim.status.condition.has_diagnostics },
    hl = fignvim.status.hl.get_attributes("diagnostics"),
    on_click = {
      name = "heirline_diagnostic",
      callback = function()
        local telescope_ok, telescope_builtin = pcall(require, "telescope.builtin")
        if telescope_ok then vim.defer_fn(telescope_builtin.diagnostics(), 100) end
      end,
    },
    update = { "DiagnosticChanged", "BufEnter" },
  })
  return fignvim.status.component.builder(fignvim.status.utils.setup_providers(opts, { "ERROR", "WARN", "INFO", "HINT" }, function(p_opts, provider)
    local out = fignvim.status.utils.build_provider(p_opts, provider)
    if out then
      out.provider = "diagnostics"
      out.opts.severity = provider
      if out.hl == nil then out.hl = { fg = "diag_" .. provider } end
    end
    return out
  end))
end

--- A function to build a set of children components for a Treesitter section
-- @param opts options for configuring diagnostic providers and the overall padding
-- @return The Heirline component table
-- @usage local heirline_component = fignvim.status.component.treesitter()
function fignvim.status.component.treesitter(opts)
  opts = fignvim.table.default_tbl(opts, {
    str = { str = "TS", icon = { kind = "ActiveTS" } },
    surround = {
      separator = "right",
      color = "treesitter_bg",
      condition = fignvim.status.condition.treesitter_available,
    },
    hl = fignvim.status.hl.get_attributes("treesitter"),
    update = { "OptionSet", pattern = "syntax" },
    init = fignvim.status.init.update_events({ "BufEnter" }),
  })
  return fignvim.status.component.builder(fignvim.status.utils.setup_providers(opts, { "str" }))
end

--- A function to build a set of children components for an LSP section
-- @param opts options for configuring lsp progress and client_name providers and the overall padding
-- @return The Heirline component table
-- @usage local heirline_component = fignvim.status.component.lsp()
function fignvim.status.component.lsp(opts)
  opts = fignvim.table.default_tbl(opts, {
    lsp_progress = {
      str = "",
      padding = { right = 1 },
      update = { "User", pattern = { "LspProgressUpdate", "LspRequest" } },
    },
    lsp_client_names = {
      str = "LSP",
      update = { "LspAttach", "LspDetach", "BufEnter" },
      icon = { kind = "ActiveLSP", padding = { right = 2 } },
    },
    hl = fignvim.status.hl.get_attributes("lsp"),
    surround = { separator = "right", color = "lsp_bg", condition = fignvim.status.condition.lsp_attached },
    on_click = {
      name = "heirline_lsp",
      callback = function()
        vim.defer_fn(function() vim.cmd.LspInfo() end, 100)
      end,
    },
  })
  return fignvim.status.component.builder(
    fignvim.status.utils.setup_providers(
      opts,
      { "lsp_progress", "lsp_client_names" },
      function(p_opts, provider, i)
        return p_opts
            and {
              flexible = i,
              fignvim.status.utils.build_provider(p_opts, fignvim.status.provider[provider](p_opts)),
              fignvim.status.utils.build_provider(p_opts, fignvim.status.provider.str(p_opts)),
            }
          or false
      end
    )
  )
end

--- A general function to build a section of fignvim status providers with highlights, conditions, and section surrounding
-- @param opts a list of components to build into a section
-- @return The Heirline component table
-- @usage local heirline_component = fignvim.status.components.builder({ { provider = "file_icon", opts = { padding = { right = 1 } } }, { provider = "filename" } })
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
  return opts.surround and fignvim.status.utils.surround(opts.surround.separator, opts.surround.color, children, opts.surround.condition) or children
end

--- Convert a component parameter table to a table that can be used with the component builder
-- @param opts a table of provider options
-- @param provider a provider in `fignvim.status.providers`
-- @return the provider table that can be used in `fignvim.status.component.builder`
function fignvim.status.utils.build_provider(opts, provider, _)
  return opts
      and {
        provider = provider,
        opts = opts,
        condition = opts.condition,
        on_click = opts.on_click,
        update = opts.update,
        hl = opts.hl,
      }
    or false
end

--- Convert key/value table of options to an array of providers for the component builder
-- @param opts the table of options for the components
-- @param providers an ordered list like array of providers that are configured in the options table
-- @param setup a function that takes provider options table, provider name, provider index and returns the setup provider table, optional, default is `fignvim.status.utils.build_provider`
-- @return the fully setup options table with the appropriately ordered providers
function fignvim.status.utils.setup_providers(opts, providers, setup)
  setup = setup or fignvim.status.utils.build_provider
  for i, provider in ipairs(providers) do
    opts[i] = setup(opts[provider], provider, i)
  end
  return opts
end

--- A utility function to get the width of the bar
-- @param is_winbar boolean true if you want the width of the winbar, false if you want the statusline width
-- @return the width of the specified bar
function fignvim.status.utils.width(is_winbar) return vim.o.laststatus == 3 and not is_winbar and vim.o.columns or vim.api.nvim_win_get_width(0) end

--- Surround component with separator and color adjustment
-- @param separator the separator index to use in `fignvim.status.env.separators`
-- @param color the color to use as the separator foreground/component background
-- @param component the component to surround
-- @param condition the condition for displaying the surrounded component
-- @return the new surrounded component
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

--- Check if a buffer is valid
-- @param bufnr the buffer to check
-- @return true if the buffer is valid or false
function fignvim.status.utils.is_valid_buffer(bufnr) -- TODO v3: remove this function
  if not bufnr or bufnr < 1 then return false end
  return vim.bo[bufnr].buflisted and vim.api.nvim_buf_is_valid(bufnr)
end

--- Get all valid buffers
-- @return array-like table of valid buffer numbers
function fignvim.status.utils.get_valid_buffers() -- TODO v3: remove this function
  return vim.tbl_filter(fignvim.status.utils.is_valid_buffer, vim.api.nvim_list_bufs())
end

--- Encode a position to a single value that can be decoded later
-- @param line line number of position
-- @param col column number of position
-- @param winnr a window number
-- @return the encoded position
function fignvim.status.utils.encode_pos(line, col, winnr) return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr) end

--- Decode a previously encoded position to it's sub parts
-- @param c the encoded position
-- @return line number, column number, window id
function fignvim.status.utils.decode_pos(c) return bit.rshift(c, 16), bit.band(bit.rshift(c, 6), 1023), bit.band(c, 63) end

--- a submodule of heirline specific functions and aliases
fignvim.status.heirline = {}

--- A helper function to get the type a tab or buffer is
-- @param self the self table from a heirline component function
-- @param prefix the prefix of the type, either "tab" or "buffer" (Default: "buffer")
-- @return the string of prefix with the type (i.e. "_active" or "_visible")
function fignvim.status.heirline.tab_type(self, prefix)
  local tab_type = ""
  if self.is_active then
    tab_type = "_active"
  elseif self.is_visible then
    tab_type = "_visible"
  end
  return (prefix or "buffer") .. tab_type
end

--- Make a list of buffers, rendering each buffer with the provided component
---@param component table
---@return table
fignvim.status.heirline.make_buflist = function(component)
  local overflow_hl = fignvim.status.hl.get_attributes("buffer_overflow", true)
  return require("heirline.utils").make_buflist(
    fignvim.status.utils.surround(
      "tab",
      function(self)
        return {
          main = fignvim.status.heirline.tab_type(self) .. "_bg",
          left = "tabline_bg",
          right = "tabline_bg",
        }
      end,
      { -- bufferlist
        init = function(self) self.tab_type = fignvim.status.heirline.tab_type(self) end,
        on_click = { -- add clickable component to each buffer
          callback = function(_, minwid) vim.api.nvim_win_set_buf(0, minwid) end,
          minwid = function(self) return self.bufnr end,
          name = "heirline_tabline_buffer_callback",
        },
        { -- add buffer picker functionality to each buffer
          condition = function(self) return self._show_picker end,
          update = false,
          init = function(self)
            local bufname = fignvim.status.provider.filename({ fallback = "empty_file" })(self)
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
          provider = function(self) return fignvim.status.provider.str({ str = self.label, padding = { left = 1, right = 1 } }) end,
          hl = fignvim.status.hl.get_attributes("buffer_picker"),
        },
        component, -- create buffer component
      },
      false -- disable surrounding
    ),
    { provider = fignvim.get_icon("ArrowLeft") .. " ", hl = overflow_hl },
    { provider = fignvim.get_icon("ArrowRight") .. " ", hl = overflow_hl },
    function() return vim.t.bufs end, -- use fignvim bufs variable
    false -- disable internal caching
  )
end

--- Run the buffer picker and execute the callback function on the selected buffer
-- @param callback function with a single parameter of the buffer number
function fignvim.status.heirline.buffer_picker(callback)
  local tabline = require("heirline").tabline
  local buflist = tabline and tabline._buflist[1]
  if buflist then
    local prev_showtabline = vim.opt.showtabline
    buflist._picker_labels = {}
    buflist._show_picker = true
    vim.opt.showtabline = 2
    vim.cmd.redrawtabline()
    local char = vim.fn.getcharstr()
    local bufnr = buflist._picker_labels[char]
    if bufnr then callback(bufnr) end
    buflist._show_picker = false
    vim.opt.showtabline = prev_showtabline
    vim.cmd.redrawtabline()
  end
end

return fignvim.status
