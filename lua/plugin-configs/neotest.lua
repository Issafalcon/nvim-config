local neotest = fignvim.plug.load_module_file("neotest")
if not neotest then
  return
end

neotest.setup({
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
    skipped = "",
  },
})
