local dap = require("dap")
local dapUtils = require("dap.utils")

local function launchChromeDebug()
  local launchUrl = vim.fn.input("Launch URL - Full path or relative to http://localhost ")

  local leadingChar = string.sub(launchUrl, 1, 1)

  if leadingChar == "/" or leadingChar == ":" then
    launchUrl = "http://localhost" .. launchUrl
  end

  local sourcemapKeys = { "/./*", "/src/*", "webpack:///./*" }
  local webrootMapPath = "${webRoot}/*"
  local sourceMapOverrides = {}
  -- sourceMapOverrides[sourcemapKeys[1]] = webrootMapPath
  -- sourceMapOverrides[sourcemapKeys[2]] = webrootMapPath
  -- sourceMapOverrides[sourcemapKeys[3]] = webrootMapPath
  -- "/*": "*",
  -- "/./~/*": "${webRoot}/node_modules/*"
  dap.set_log_level("TRACE")
  dap.run({
    type = "chrome",
    request = "launch",
    stopOnEntry = true,
    url = launchUrl,
    webRoot = "${workspaceFolder}/src",
    runtimeExecutable = "/usr/bin/google-chrome",
    -- sourceMapPathOverrides = sourceMapOverrides
  })
end

local function attachNetCoreDb()
  -- dap.set_log_level("TRACE")

  dap.run({
    type = "netcoredbg",
    name = "attach - netcoredbg",
    request = "attach",
    processId = function()
      -- TODO: Select a project and launchsettings to run with then dotnet run and attach to that PID
      return dapUtils.pick_process()
    end,
    -- program = function()
    --   return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    -- end,
  })
end

local function launchNetCoreDbg()
  -- dap.set_log_level("TRACE")

  dap.run({
    type = "netcoredbg",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
      return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
    end,
  })
end

local function mochaTestDebug()
  local file_name = vim.fn.fnamemodify(vim.fn.expand('%'), ':t:r')
  dap.set_log_level("TRACE")

  dap.run({
    type = "node2",
    request = "launch",
    name = "Debug Mocha",
    program = "${workspaceFolder}/node_modules/mocha/bin/_mocha",
    stopOnEntry = true,
    args = { "${workspaceFolder}/**/*" .. file_name .. ".js", "--no-timeouts" },
    cwd = "${workspaceFolder}",
    env = { "NODE_ENV='testing'" },
    sourceMaps = true
    -- outFiles = { "${workspaceFolder}/**/*.js" },
  })
end

local function launchBashDebug()
  dap.run({
    type = "bashdb",
    name = "launch - bashDebug",
    program = "${file}",
    request = "launch",
    env = {},
    cwd = "${workspaceFolder}",
    pathBash = "bash",
    pathCat = "cat",
    pathMkfifo = "mkfifo",
    pathPkill = "pkill",
    pathBashdb = { os.getenv("HOME") .. "/debug-adapters/vscode-bash-debug/bashdb_dir/bashdb" },
    pathBashdbLib = { os.getenv("HOME") .. "/debug-adapters/vscode-bash-debug/bashdb_dir" },
    terminalKind = "integrated",
    args = function()
      return vim.fn.split(vim.fn.input("Scripts args:"))
    end,
  })
end

local function startDebugLaunch()
  if dap.session() then
    dap.terminate()
    dap.close()
  end

  if vim.bo.filetype == "typescript" or vim.bo.filetype == "typescriptreact" or vim.bo.filetype == "svelte" then
    launchChromeDebug()
  elseif vim.bo.filetype == "cs" then
    launchNetCoreDbg()
  elseif vim.bo.filetype == "sh" then
    launchBashDebug()
  end
end

local function startDebugAttach()
  if dap.session() then
    dap.disconnect()
    dap.close()
  end

  if vim.bo.filetype == "typescript" or vim.bo.filetype == "typescriptreact" then
    launchChromeDebug()
  elseif vim.bo.filetype == "cs" then
    attachNetCoreDb()
  end
end

local function startDebugTest()
  if dap.session() then
    dap.disconnect()
    dap.close()
  end

  if vim.bo.filetype == "typescript" or vim.bo.filetype == "typescriptreact" then
    -- TODO: Use the 'jester' plugin to debug jest test here
    -- TODO: Provide select function to determine which test runner is being used (Jest, Mocha) then use corresponding config
    mochaTestDebug()
  elseif vim.bo.filetype == "cs" then
    vim.cmd(":OmnisharperDebugTest")
  end
end

return {
  startDebugAttach = startDebugAttach,
  startDebugLaunch = startDebugLaunch,
  startDebugTest = startDebugTest,
}
