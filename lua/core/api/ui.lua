fignvim.ui = {}

--- Initialize icons used throughout the user interface
fignvim.ui.initialize_icons = function()
  fignvim.icons = fignvim.plug.opts("icons", require "core.icons.nerd_font")
  fignvim.text_icons = fignvim.plug.opts("text_icons", require "core.icons.text")
end

--- Get an icon from `lspkind` if it is available and return it
---@param kind string the kind of icon in `lspkind` to retrieve
---@return string the icon
fignvim.ui.get_icon = function(kind)
  local icon_pack = vim.g.icons_enabled and "icons" or "text_icons"
  if not fignvim[icon_pack] then fignvim.ui.initialize_icons() end
  return fignvim[icon_pack] and fignvim[icon_pack][kind] or ""
end

--- Wrapper function for neovim echo API
-- @param messages an array like table where each item is an array like table of strings to echo
fignvim.ui.echo = function(messages)
  -- if no parameter provided, echo a new line
  messages = messages or { { "\n" } }
  if type(messages) == "table" then vim.api.nvim_echo(messages, false, {}) end
end

return fignvim.ui
