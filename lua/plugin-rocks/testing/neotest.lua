local neotest_keys = {
  {
    "n",
    "<leader>us",
    function()
      require("neotest").summary.toggle()
    end,
    { desc = "Neotest: Open test summary window" },
  },
  {
    "n",
    "<leader>uf",
    function()
      require("neotest").run.run(vim.fn.expand("%"))
    end,
    { desc = "Neotest: Run tests in file" },
  },
  {
    "n",
    "<leader>un",
    function()
      require("neotest").run.run()
    end,
    { desc = "Neotest: Run nearest test" },
  },
  {
    "n",
    "<leader>ud",
    function()
      require("neotest").run.run({ strategy = "dap" })
    end,
    { desc = "Neotest: Debug nearest test" },
  },
  {
    "n",
    "<leader>ua",
    function()
      require("neotest").run.run({ suite = true })
    end,
    { desc = "Neotest: Run all tests in suite" },
  },
}

local neotest = require("neotest")
neotest.setup({
  log_level = 1, -- For verbose logs
  adapters = {
    require("neotest-python")({
      dap = { justMyCode = false },
    }),
    require("neotest-plenary"),
    require("neotest-dotnet")({
      discovery_root = "solution",
    }),
    require("neotest-jest")({
      jestCommand = "npm test -- --runInBand --no-cache --watchAll=false",
      env = { CI = "true" },
      cwd = function(path)
        return vim.fn.getcwd()
      end,
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
    skipped = "",
  },
})

fignvim.mappings.create_keymaps(neotest_keys)
