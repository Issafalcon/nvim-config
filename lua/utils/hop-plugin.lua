
local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

require("hop").setup()

keymap("n", '<leader><leader>w', "<cmd>lua require'hop'.hint_words()<cr>", opts)
keymap("n", '<leader><leader>o', "<cmd>lua require'hop'.hint_char1()<cr>", opts)
keymap("n", '<leader><leader>t', "<cmd>lua require'hop'.hint_char2()<cr>", opts)
keymap("n", '<leader><leader>/', "<cmd>lua require'hop'.hint_patterns()<cr>", opts)
keymap("n", '<leader><leader>l', "<cmd>lua require'hop'.hint_lines()<cr>", opts)

keymap("v", '<leader><leader>w', "<cmd>lua require'hop'.hint_words()<cr>", opts)
keymap("v", '<leader><leader>o', "<cmd>lua require'hop'.hint_char1()<cr>", opts)
keymap("v", '<leader><leader>t', "<cmd>lua require'hop'.hint_char2()<cr>", opts)
keymap("v", '<leader><leader>/', "<cmd>lua require'hop'.hint_patterns()<cr>", opts)
keymap("v", '<leader><leader>l', "<cmd>lua require'hop'.hint_lines()<cr>", opts)
