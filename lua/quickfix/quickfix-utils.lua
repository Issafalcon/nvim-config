local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
local maps = require("custom_config").mappings

-- QF List toggle and navigation
vim.g.issafalcon_qf_g = 0
vim.g.issafalcon_qf_l = 0

function _G.ToggleQFList(global)
  if global == 1 then
    if vim.g.issafalcon_qf_g == 1 then
      vim.g.issafalcon_qf_g = 0
      vim.cmd('cclose')
    else
      vim.g.issafalcon_qf_g = 1
      vim.cmd('copen')
    end
  else
    if vim.g.issafalcon_qf_l == 1 then
      vim.g.issafalcon_qf_l = 0
      vim.cmd('lclose')
    else
      vim.g.issafalcon_qf_l = 1
      vim.cmd('lopen')
    end
  end
end

-- Vim-unimpaired has "[" and "]" to navigate next and previous items in both lists
keymap('n', maps.toggle_lists.quickfix, ':lua ToggleQFList(1)<CR>', opts)
keymap('n', maps.toggle_lists.loclist, ':lua ToggleQFList(0)<CR>', opts)
