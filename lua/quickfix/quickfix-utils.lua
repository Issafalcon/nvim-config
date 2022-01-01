local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

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
keymap('n', '<C-q>', ':lua ToggleQFList(1)<CR>', opts)
keymap('n', '<leader>q', ':lua ToggleQFList(0)<CR>', opts)
