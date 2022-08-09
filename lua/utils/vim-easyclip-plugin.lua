local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

vim.g.EasyClipAutoFormat = 0
vim.g.EasyClipUsePasteToggleDefaults = 0

keymap("n", "<C-a>", "<plug>EasyClipSwapPasteForward", {})
keymap("n", "<C-s>", "<plug>EasyClipSwapPasteForward", {})

-- Remap to create marks (easy-snip overrides the 'm' default mapping for it's 'cut' operation)
keymap("n", "\\m", "m", opts)
