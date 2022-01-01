local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

require('telescope').load_extension('dap')
keymap('n', '<leader>dtf', ':Telescope dap frames<CR>', opts)
keymap('n', '<leader>dtc', ':Telescope dap commands<CR>', opts)
keymap('n', '<leader>dtb', ':Telescope dap list_breakpoints<CR>', opts)
