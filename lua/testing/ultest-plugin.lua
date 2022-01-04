local opts = { silent = true }
local keymap = vim.api.nvim_set_keymap

-- Ultest Keybindings
keymap('n', '<leader>us', '<Plug>(ultest-summary-toggle)', opts)
keymap('n', '<leader>uf', '<Plug>(ultest-run-file)', opts)
keymap('n', '<leader>un', '<Plug>(ultest-run-nearest)', opts)
keymap('n', '<leader>uc', ':UltestClear<CR>', opts)
keymap('n', '<leader>uo', '<Plug>(ultest-output-jump)', opts)
keymap('n', '<leader>[u', '<Plug>(ultest-prev-fail)', opts)
keymap('n', '<leader>]u', '<Plug>(ultest-next-fail)', opts)
