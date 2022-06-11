local opts = { silent = true }
local keymap = vim.api.nvim_set_keymap

require("neotest").setup({
  adapters = {
    require("neotest-python")({
      dap = { justMyCode = false },
    }),
    require("neotest-plenary"),
    require("neotest-vim-test")({
      ignore_file_types = { "python", "vim", "lua" },
    }),
  },
})

keymap('n', '<leader>us', 'lua require("neotest").summary.toggle()', opts)
keymap('n', '<leader>uf', 'lua require("neotest").run.run(vim.fn.expand("%"))', opts)
keymap('n', '<leader>un', 'lua require("neotest").run.run()', opts)
