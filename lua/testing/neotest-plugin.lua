local opts = { silent = true }
local keymap = vim.api.nvim_set_keymap

require("neotest").setup({
  log_level = 1, -- For verbose logs
  adapters = {
    require("neotest-python")({
      dap = { justMyCode = false },
    }),
    require("neotest-plenary"),
    require("neotest-dotnet"),
    require("neotest-vim-test")({
      ignore_file_types = { "python", "vim", "lua", "cs" },
    }),
    require("neotest-jest")({
      jestCommand = "npm test --",
    }),
  },
  icons = {
    expanded = "",
    child_prefix = "",
    child_indent = "",
    final_child_prefix = "",
    non_collapsible = "",
    collapsed = "",
    passed = "",
    running = "",
    failed = "",
    unknown = "",
    skipped = ""
  },
})

keymap("n", "<leader>us", ':lua require("neotest").summary.toggle()<cr>', opts)
keymap("n", "<leader>uf", ':lua require("neotest").run.run(vim.fn.expand("%"))<cr>', opts)
keymap("n", "<leader>un", ':lua require("neotest").run.run()<cr>', opts)
