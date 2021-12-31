local opts = { silent = true }
local keymap = vim.api.nvim_set_keymap

-- Start interactive EasyAlign in visual mode (e.g. vipga)
keymap("n", "<A-u>", ":UndotreeToggle<CR>", opts)
