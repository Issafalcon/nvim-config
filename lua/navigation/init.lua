require("navigation.harpoon-plugin")
require("navigation.hop-plugin")
if vim.fn.has('wsl') or vim.fn.has('unix') then
  require("navigation.rnvimr-plugin")
end
require("navigation.nvim-tree-plugin")
