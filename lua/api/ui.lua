fignvim.ui = {}

local bool2str = function(bool) return bool and "on" or "off" end

--- Initialize icons used throughout the user interface
function fignvim.ui.initialize_icons()
  fignvim.ui.icons = require("icons.nerd_font")
  fignvim.ui.text_icons = require("icons.text")
  fignvim.ui.lspkind_icons = require("icons.lspkind")
end

function fignvim.ui.set_colourscheme()
  local ui_settings = require("user-configs.ui")
  vim.cmd.colorscheme(ui_settings.theme.colourscheme)
end
--- Get an icon from `lspkind` if it is available and return it
---@param kind string the kind of icon in `lspkind` to retrieve
---@return string the icon
function fignvim.ui.get_icon(kind)
  local icon_pack = vim.g.icons_enabled and "icons" or "text_icons"
  if not fignvim.ui[icon_pack] then fignvim.ui.initialize_icons() end
  return fignvim.ui[icon_pack] and fignvim.ui[icon_pack][kind] or ""
end

--- A utility function to stylize a string with an icon from lspkind, separators, and left/right padding
---@param str string | boolean string the string to stylize
---@param opts table options of `{ padding = { left = 0, right = 0 }, separator = { left = "|", right = "|" }, show_empty = false, icon = { kind = "NONE", padding = { left = 0, right = 0 } } }`
---@return string the stylized string
---@usage local string = fignvim.status.utils.stylize("Hello", { padding = { left = 1, right = 1 }, icon = { kind = "String" } })
function fignvim.ui.stylize(str, opts)
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

--- Wrapper function for neovim echo API
-- @param messages table<string, table> an array like table where each item is an array like table of strings to echo
function fignvim.ui.echo(messages)
  -- if no parameter provided, echo a new line
  messages = messages or { { "\n" } }
  if type(messages) == "table" then vim.api.nvim_echo(messages, false, {}) end
end

--- Serve a notification with a title of AstroNvim
---@param msg string the notification body
---@param type? string the type of the notification (:help vim.log.levels)
---@param opts? table of nvim-notify options to use (:help notify-options)
function fignvim.ui.notify(msg, type, opts)
  vim.notify(msg, type, fignvim.table.default_tbl(opts or {}, { title = "FigNvim" }))
end

--- Taken from https://github.com/kevinhwang91/nvim-bqf#format-new-quickfix
--- Used when setting up ui to make quickfix list more attractive
---@param info any Information avout the qf item in the list
---@return
function fignvim.ui.qftf(info)
  local fn = vim.fn
  local items
  local ret = {}
  -- The name of item in list is based on the directory of quickfix window.
  -- Change the directory for quickfix window make the name of item shorter.
  -- It's a good opportunity to change current directory in quickfixtextfunc :)
  --
  -- local alterBufnr = fn.bufname('#') -- alternative buffer is the buffer before enter qf window
  -- local root = getRootByAlterBufnr(alterBufnr)
  -- vim.cmd(('noa lcd %s'):format(fn.fnameescape(root)))
  --
  if info.quickfix == 1 then
    items = fn.getqflist({ id = info.id, items = 0 }).items
  else
    items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end
  local limit = 31
  local fnameFmt1, fnameFmt2 = "%-" .. limit .. "s", "…%." .. (limit - 1) .. "s"
  local validFmt = "%s │%5d:%-3d│%s %s"
  for i = info.start_idx, info.end_idx do
    local e = items[i]
    local fname = ""
    local str
    if e.valid == 1 then
      if e.bufnr > 0 then
        fname = fn.bufname(e.bufnr)
        if fname == "" then
          fname = "[No Name]"
        else
          fname = fname:gsub("^" .. vim.env.HOME, "~")
        end
        -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
        if #fname <= limit then
          fname = fnameFmt1:format(fname)
        else
          fname = fnameFmt2:format(fname:sub(1 - limit))
        end
      end
      local lnum = e.lnum > 99999 and -1 or e.lnum
      local col = e.col > 999 and -1 or e.col
      local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper()
      str = validFmt:format(fname, lnum, col, qtype, e.text)
    else
      str = e.text
    end
    table.insert(ret, str)
  end
  return ret
end
--- Delete the syntax matching rules for URLs/URIs if set
function fignvim.ui.delete_url_match()
  for _, match in ipairs(vim.fn.getmatches()) do
    if match.group == "HighlightURL" then vim.fn.matchdelete(match.id) end
  end
end

--- Add syntax matching rules for highlighting URLs/URIs
function fignvim.ui.set_url_match()
  fignvim.ui.delete_url_match()
  if vim.g.highlighturl_enabled then vim.fn.matchadd("HighlightURL", fignvim.vars.url_matcher, 15) end
end

--- Toggle URL/URI syntax highlighting rules
function fignvim.ui.toggle_url_match()
  vim.g.highlighturl_enabled = not vim.g.highlighturl_enabled
  fignvim.ui.set_url_match()
end

function fignvim.ui.toggle_line_numbers() vim.wo.number = not vim.wo.number end

function fignvim.ui.toggle_relative_line_numbers() vim.wo.relativenumber = not vim.wo.relativenumber end

function fignvim.ui.toggle_fix_list(global)
  if global then
    if vim.g.quickfix_open then
      vim.g.quickfix_open = false
      vim.cmd("cclose")
    else
      vim.g.quickfix_open = true
      vim.cmd("copen")
    end
  else
    if vim.g.loclist_open then
      vim.g.loclist_open = false
      vim.cmd("lclose")
    else
      vim.g.loclist_open = true
      vim.cmd("lopen")
    end
  end
end

function fignvim.ui.configure_diagnostics()
  local diagnostic_settings = require("user-configs.diagnostics").config
  vim.diagnostic.config(diagnostic_settings[bool2str(vim.g.diagnostics_enabled)])
end

--- Toggle diagnostics
function fignvim.ui.toggle_diagnostics()
  local status = "on"
  if vim.g.status_diagnostics_enabled then
    if vim.g.diagnostics_enabled then
      vim.g.diagnostics_enabled = false
      status = "virtual text off"
    else
      vim.g.status_diagnostics_enabled = false
      status = "fully off"
    end
  else
    vim.g.diagnostics_enabled = true
    vim.g.status_diagnostics_enabled = true
  end

  local on_off = vim.g.diagnostics_enabled and "on" or "off"
  vim.diagnostic.config(require("user-configs.diagnostics")[on_off])
  fignvim.ui.notify(string.format("diagnostics %s", status))
end

--- Toggle auto format
function fignvim.ui.toggle_autoformat()
  vim.g.autoformat_enabled = not vim.g.autoformat_enabled
  fignvim.notify(string.format("Autoformatting %s", bool2str(vim.g.autoformat_enabled)))
end

--- Get highlight properties for a given highlight name
---@param name string highlight group name
---@return table of highlight group properties
function fignvim.ui.get_hlgroup(name, fallback)
  local hl = vim.fn.hlexists(name) == 1 and vim.api.nvim_get_hl_by_name(name, vim.o.termguicolors) or {}
  return fignvim.table.default_tbl(
    vim.o.termguicolors and { fg = hl.foreground, bg = hl.background, sp = hl.special }
      or { cterfm = hl.foreground, ctermbg = hl.background },
    fallback
  )
end

return fignvim.ui
