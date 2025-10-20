vim.pack.add({
  { src = "https://github.com/nvim-neotest/nvim-nio" },
  { src = "https://github.com/nvim-neotest/neotest" },
  { src = "https://github.com/nvim-neotest/neotest-python" },
  { src = "https://github.com/nvim-neotest/neotest-plenary" },
  { src = "https://github.com/nvim-neotest/neotest-jest" },
  { src = "https://github.com/Issafalcon/neotest-dotnet" },
})

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
      cwd = function(_)
        return vim.fn.getcwd()
      end,
    }),
  },
})

vim.keymap.set("n", "<leader>us", function()
  require("neotest").summary.toggle()
end, { desc = "Neotest: Open test summary window" })

vim.keymap.set("n", "<leader>uf", function()
  require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Neotest: Run tests in file" })

vim.keymap.set("n", "<leader>un", function()
  require("neotest").run.run()
end, { desc = "Neotest: Run nearest test" })

vim.keymap.set("n", "<leader>ud", function()
  require("neotest").run.run({ strategy = "dap" })
end, { desc = "Neotest: Debug nearest test" })

vim.keymap.set("n", "<leader>ua", function()
  require("neotest").run.run({ suite = true })
end, { desc = "Neotest: Run all tests in suite" })
