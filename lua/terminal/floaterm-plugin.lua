local lazygit_open = ":FloatermNew --height=0.9 --width=0.9 --wintype=float --name=Lazygit lazygit<CR>"
local ranger_open = ":FloatermNew --height=0.8 --width=0.8 --wintype=float --name=Ranger --autoclose=2 ranger --cmd='set draw_borders both'<CR>"

vim.api.nvim_set_keymap("n", "<leader>lg", lazygit_open, {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "-", ranger_open, {noremap = true, silent = true})

vim.keymap.set('n', '<c-y>', ":FloatermToggle<CR>")
vim.keymap.set('i', '<c-y>', '<ESC>:FloatermToggle<CR>')
vim.keymap.set('t', '<c-y>', '<c-\\><c-n>:FloatermToggle<CR>')
