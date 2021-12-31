local opts = { silent = true }
local keymap = vim.api.nvim_set_keymap

-- Start interactive EasyAlign in visual mode (e.g. vipga)
keymap("x", "ga", "<Plug>(EasyAlign)", opts)

-- Start interactive EasyAlign for a motion/text object (e.g. gaip)
keymap("n", "ga", "<Plug>(EasyAlign)", opts)
