local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

keymap("n", "<leader>m", ":MaximizerToggle!<CR>", opts)
