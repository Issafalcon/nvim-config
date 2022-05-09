local lazygit_open = ":FloatermNew --height=0.9 --width=0.9 --wintype=float --name=Lazygit --autoclose=0 lazygit<CR>"
local ranger_open = ":FloatermNew --height=0.8 --width=0.8 --wintype=float --name=Ranger --autoclose=2 ranger --cmd='set draw_borders both'<CR>"

vim.keymap.set("n", "<leader>lg", lazygit_open, {noremap = true, silent = true})
vim.keymap.set("n", "-", ranger_open, {noremap = true, silent = true})

vim.keymap.set('n', '<c-y>', ":FloatermToggle<CR>")
vim.keymap.set('n', '<c-t>', ":FloatermNew --height=0.3 --width=0.3 --wintype=split<CR>")
vim.keymap.set('i', '<c-y>', '<ESC>:FloatermToggle<CR>')
vim.keymap.set('t', '<c-t>', "<c-\\><c-n>:FloatermNew --height=0.3 --width=0.3 --wintype=split<CR>")
vim.keymap.set('t', '<c-y>', '<c-\\><c-n>:FloatermToggle<CR>')
vim.keymap.set("t", "<esc>", [[<C-\><C-n>]])
vim.keymap.set("t", "<C-h>", [[<C-\><C-n>:FloatermPrev<CR>]])
vim.keymap.set("t", "<C-l>", [[<C-\><C-n>:FloatermNext<CR>]])
