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
    function()
      if vim.bo.filetype == "cs" then
        require("neotest").run.run({ strategy = require("neotest-dotnet.strategies.netcoredbg"), is_custom_dotnet_debug = true })
      else
        require("neotest").run.run({ strategy = "dap" })
      end
    end,
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
    "nvim-neotest/neotest-vim-test",
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
        skipped = "",
      },
    })
    fignvim.mappings.register_keymap_group("Testing", neotest_keys, false)
  end,
}

return fignvim.module.enable_registered_plugins({
  ["neotest"] = neotest_spec,
}, "testing")
