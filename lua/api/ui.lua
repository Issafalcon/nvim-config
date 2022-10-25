fignvim.ui = {}

--- Initialize icons used throughout the user interface
function fignvim.ui.initialize_icons()
  fignvim.icons = fignvim.plug.opts("icons", require "core.icons.nerd_font")
  fignvim.text_icons = fignvim.plug.opts("text_icons", require "core.icons.text")
end

--- Get an icon from `lspkind` if it is available and return it
---@param kind string the kind of icon in `lspkind` to retrieve
---@return string the icon
function fignvim.ui.get_icon(kind)
  local icon_pack = vim.g.icons_enabled and "icons" or "text_icons"
  if not fignvim[icon_pack] then fignvim.ui.initialize_icons() end
  return fignvim[icon_pack] and fignvim[icon_pack][kind] or ""
end

--- Wrapper function for neovim echo API
-- @param messages an array like table where each item is an array like table of strings to echo
function fignvim.ui.echo(messages)
  -- if no parameter provided, echo a new line
  messages = messages or { { "\n" } }
  if type(messages) == "table" then vim.api.nvim_echo(messages, false, {}) end
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
      vim.cmd('cclose')
    else
      vim.g.quickfix_open = true
      vim.cmd('copen')
    end
  else
    if vim.g.loclist_open then
      vim.g.loclist_open = false
      vim.cmd('lclose')
    else
      vim.g.loclist_open = true
      vim.cmd('lopen')
    end
  end
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

return fignvim.ui
