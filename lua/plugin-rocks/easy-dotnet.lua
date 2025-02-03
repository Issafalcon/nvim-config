local function get_secret_path(secret_guid)
  local path = ""
  local home_dir = vim.fn.expand("~")
  if require("easy-dotnet.extensions").isWindows() then
    local secret_path = home_dir
      .. "\\AppData\\Roaming\\Microsoft\\UserSecrets\\"
      .. secret_guid
      .. "\\secrets.json"
    path = secret_path
  else
    local secret_path = home_dir
      .. "/.microsoft/usersecrets/"
      .. secret_guid
      .. "/secrets.json"
    path = secret_path
  end
  return path
end

local dotnet = require("easy-dotnet")
-- Options are not required
dotnet.setup({
  --Optional function to return the path for the dotnet sdk (e.g C:/ProgramFiles/dotnet/sdk/8.0.0)
  -- get_sdk_path = get_sdk_path,
  ---@type TestRunnerOptions
  test_runner = {
    ---@type "split" | "float" | "buf"
    viewmode = "split",
    enable_buffer_test_execution = true, --Experimental, run tests directly from buffer
    noBuild = false,
    noRestore = true,
    icons = {
      passed = "",
      skipped = "",
      failed = "",
      success = "",
      reload = "",
      test = "",
      sln = "󰘐",
      project = "󰘐",
      dir = "",
      package = "",
    },
    mappings = {
      run_test_from_buffer = { lhs = "<leader>r", desc = "run test from buffer" },
      filter_failed_tests = { lhs = "<leader>fe", desc = "filter failed tests" },
      debug_test = { lhs = "<leader>d", desc = "debug test" },
      go_to_file = { lhs = "g", desc = "got to file" },
      run_all = { lhs = "<leader>R", desc = "run all tests" },
      run = { lhs = "<leader>r", desc = "run test" },
      peek_stacktrace = {
        lhs = "<leader>p",
        desc = "peek stacktrace of failed test",
      },
      expand = { lhs = "o", desc = "expand" },
      expand_all = { lhs = "E", desc = "expand all" },
      collapse_all = { lhs = "W", desc = "collapse all" },
      close = { lhs = "q", desc = "close testrunner" },
      refresh_testrunner = { lhs = "<C-r>", desc = "refresh testrunner" },
    },
    --- Optional table of extra args e.g "--blame crash"
    additional_args = {},
  },
  secrets = {
    path = get_secret_path,
  },
  csproj_mappings = true,
  fsproj_mappings = true,
  auto_bootstrap_namespace = true,
})

-- Example command
-- vim.api.nvim_create_user_command("Secrets", function()
--   dotnet.secrets()
-- end, {})

-- Example keybinding
-- vim.keymap.set("n", "<C-p>", function()
--   dotnet.run_project()
-- end)
