---@type FigNvimPluginConfig
local M = {}

M.lazy_opts = {
  open_for_directories = false,
  open_multiple_tabs = true,
  keymaps = {
    show_help = "<f1>",
  },
}

M.lazy_init = function()
  vim.g.loaded_netrwPlugin = 1
end

return M
