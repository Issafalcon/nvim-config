fignvim.ui = {}

--- Initialize icons used throughout the user interface
function fignvim.ui.initialize_icons()
  fignvim.icons = fignvim.plug.opts("icons", require("core.icons.nerd_font"))
  fignvim.text_icons = fignvim.plug.opts("text_icons", require("core.icons.text"))
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
  if not fignvim[icon_pack] then
    fignvim.ui.initialize_icons()
  end
  return fignvim[icon_pack] and fignvim[icon_pack][kind] or ""
end

--- A utility function to stylize a string with an icon from lspkind, separators, and left/right padding
---@param str | boolean string the string to stylize
---@param opts table options of `{ padding = { left = 0, right = 0 }, separator = { left = "|", right = "|" }, show_empty = false, icon = { kind = "NONE", padding = { left = 0, right = 0 } } }`
---@return string the stylized string
---@usage local string = fignvim.status.utils.stylize("Hello", { padding = { left = 1, right = 1 }, icon = { kind = "String" } })
function fignvim.ui.stylize(str, opts)
  opts = fignvim.default_tbl(opts, {
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
-- @param messages an array like table where each item is an array like table of strings to echo
function fignvim.ui.echo(messages)
  -- if no parameter provided, echo a new line
  messages = messages or { { "\n" } }
  if type(messages) == "table" then
    vim.api.nvim_echo(messages, false, {})
  end
end

--- Delete the syntax matching rules for URLs/URIs if set
function fignvim.ui.delete_url_match()
  for _, match in ipairs(vim.fn.getmatches()) do
    if match.group == "HighlightURL" then
      vim.fn.matchdelete(match.id)
    end
  end
end

--- Add syntax matching rules for highlighting URLs/URIs
function fignvim.ui.set_url_match()
  fignvim.ui.delete_url_match()
  if vim.g.highlighturl_enabled then
    vim.fn.matchadd("HighlightURL", fignvim.vars.url_matcher, 15)
  end
end

--- Toggle URL/URI syntax highlighting rules
function fignvim.ui.toggle_url_match()
  vim.g.highlighturl_enabled = not vim.g.highlighturl_enabled
  fignvim.ui.set_url_match()
end

function fignvim.ui.toggle_line_numbers()
  vim.wo.number = not vim.wo.number
end

function fignvim.ui.toggle_relative_line_numbers()
  vim.wo.relativenumber = not vim.wo.relativenumber
end

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
  local ui_settings = require("user-configs.ui")
  vim.diagnostic.config(ui_settings.config[vim.g.diagnostics_enabled and "on" or "off"])
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
  vim.diagnostic.config(fignvim.config.get_config("diagnostics")[on_off])
  -- fignvim.ui.notify(string.format("diagnostics %s", status))
end

--- Toggle auto format
function fignvim.ui.toggle_autoformat()
  vim.g.autoformat_enabled = not vim.g.autoformat_enabled
  local on_off = vim.g.autoformat_enabled and "on" or "off"
  -- fignvim.notify(string.format("Autoformatting %s", bool2str(vim.g.autoformat_enabled)))
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
