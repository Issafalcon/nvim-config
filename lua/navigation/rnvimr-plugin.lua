-- Make ranger replace Netrw and be the file explorer
vim.g.rnvimr_enable_ex = 1
vim.g.rnvimr_draw_border = 1

-- Keep showing Ranger after choosing a file
vim.g.rnvimr_enable_picker = 1
vim.g.rnvimr_edit_cmd = 'edit'

-- Make neovim wipe buffers corresponding to files deleted in Ranger
vim.g.rnvimr_enable_bw = 1

-- Change the border's color
vim.g.rnvimr_border_attr = { fg = 14, bg = -1 }

vim.cmd([[let g:rnvimr_action = {
            \ '<C-i>': 'NvimEdit tabedit',
            \ '<C-x>': 'NvimEdit split',
            \ '<C-v>': 'NvimEdit vsplit',
            \ 'gw': 'JumpNvimCwd',
            \ 'yw': 'EmitRangerCwd'
\ }]])

-- Draw border with both
vim.g.rnvimr_ranger_cmd = { 'ranger', '--cmd=set draw_borders both' }

vim.api.nvim_set_keymap('n', '-', ':RnvimrToggle<CR>', { noremap = true, silent = true })
