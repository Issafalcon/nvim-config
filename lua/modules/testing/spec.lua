local neotest_keys = {
  {
    "n",
    "<leader>us",
    function() require("neotest").summary.toggle() end,
    { desc = "Neotest: Open test summary window" },
  },
  { "n", "<leader>uf", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Neotest: Run tests in file" } },
  { "n", "<leader>un", function() require("neotest").run.run() end, { desc = "Neotest: Run nearest test" } },
  {
    "n",
    "<leader>ud",
    function() require("neotest").run.run({ strategy = "dap" }) end,
    { desc = "Neotest: Debug nearest test" },
  },
  {
    "n",
    "<leader>ua",
    function() require("neotest").run.run({ suite = true }) end,
    { desc = "Neotest: Run all tests in suite" },
  },
}

local neotest_spec = {
  "nvim-neotest/neotest",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-neotest/neotest-python",
    "nvim-neotest/neotest-plenary",
    "Issafalcon/neotest-dotnet",
    "haydenmeade/neotest-jest",
    "antoinemadec/FixCursorHold.nvim",
  },
  keys = fignvim.mappings.make_lazy_keymaps(neotest_keys, true),
  config = function()
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
          cwd = function(path) return vim.fn.getcwd() end,
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
  end,
}

return fignvim.module.enable_registered_plugins({
  ["neotest"] = neotest_spec,
}, "testing")
