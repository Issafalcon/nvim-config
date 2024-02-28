fignvim.ui = {}

local bool2str = function(bool) return bool and "on" or "off" end

--- Initialize icons used throughout the user interface
function fignvim.ui.initialize_icons()
  fignvim.ui.icons = require("core.icons.nerd_font")
  fignvim.ui.text_icons = require("core.icons.text")
  fignvim.ui.lspkind_icons = require("core.icons.lspkind")
end

--- Get an icon from `lspkind` if it is available and return it
---@param kind string the kind of icon in `lspkind` to retrieve
---@return string the icon
function fignvim.ui.get_icon(kind)
  local icon_pack = "icons"
  if not fignvim.ui[icon_pack] then fignvim.ui.initialize_icons() end
  return fignvim.ui[icon_pack] and fignvim.ui[icon_pack][kind] or ""
end

--- Wrapper function for neovim echo API
-- @param messages table<string, table> an array like table where each item is an array like table of strings to echo
function fignvim.ui.echo(messages)
  -- if no parameter provided, echo a new line
  messages = messages or { { "\n" } }
  if type(messages) == "table" then vim.api.nvim_echo(messages, false, {}) end
end

--- Serve a notification with a title of FigNvim
---@param msg string the notification body
---@param type number|nil the type of the notification (:help vim.log.levels)
---@param opts table|nil of nvim-notify options to use (:help notify-options)
function fignvim.ui.notify(msg, type, opts) vim.notify(msg, type, fignvim.table.default_tbl(opts or {}, { title = "FigNvim" })) end

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

--- Toggle auto format
function fignvim.ui.toggle_autoformat()
  vim.g.autoformat_enabled = not vim.g.autoformat_enabled
  fignvim.ui.notify(string.format("Autoformatting %s", bool2str(vim.g.autoformat_enabled)))
end

--- Get highlight properties for a given highlight name
---@param name string highlight group name
---@return table of highlight group properties
function fignvim.ui.get_hlgroup(name, fallback)
  local hl = vim.fn.hlexists(name) == 1 and vim.api.nvim_get_hl(0, { name = name }) or {}
  return fignvim.table.default_tbl(
    vim.o.termguicolors and { fg = hl.foreground, bg = hl.background, sp = hl.special }
      or { cterfm = hl.foreground, ctermbg = hl.background },
    fallback
  )
end
--- Get a list of registered null-ls providers for a given filetype
-- @param filetype the filetype to search null-ls for
-- @return a list of null-ls sources
function fignvim.ui.none_ls_providers(filetype)
  local registered = {}
  -- try to load null-ls
  local sources_avail, sources = pcall(require, "null-ls.sources")
  if sources_avail then
    -- get the available sources of a given filetype
    for _, source in ipairs(sources.get_available(filetype)) do
      -- get each source name
      for method in pairs(source.methods) do
        registered[method] = registered[method] or {}
        table.insert(registered[method], source.name)
      end
    end
  end
  -- return the found null-ls sources
  return registered
end

--- Get the null-ls sources for a given null-ls method
-- @param filetype the filetype to search null-ls for
-- @param method the null-ls method (check null-ls documentation for available methods)
-- @return the available sources for the given filetype and method
function fignvim.ui.none_ls_sources(filetype, method)
  local methods_avail, methods = pcall(require, "null-ls.methods")
  return methods_avail and fignvim.ui.none_ls_providers(filetype)[methods.internal[method]] or {}
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

return fignvim.ui
