local status_ok, windows = pcall(require, "windows")
if not status_ok then
  return
end
local opts = { noremap = true, silent = true }
local mapper = require("utils.mapper")
local maps = require("custom_config").mappings


vim.o.winwidth = 10
vim.o.winminwidth = 10
vim.o.equalalways = false

windows.setup()

mapper.map("n", maps.resize_window.maximize, ":WindowsMaximize<CR>", opts, "Window", "window_maximize",
  "Toggle window maximize")
mapper.map("n", maps.resize_window.toggle_autosize, ":WindowsToggleAutowidth<CR>", opts, "Window",
  "window_toggle_autowidth", "Toggles whether Windows will autoresize on focus")
