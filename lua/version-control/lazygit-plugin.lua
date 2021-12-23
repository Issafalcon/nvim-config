local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

-- Mappings
keymap("n", "<leader>lg", ":LazyGit<CR>", opts)
