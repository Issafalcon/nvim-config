local dap = require("dap")
local dapUtils = require("dap.utils")

local function launchChromeDebug()
  local launchUrl = vim.fn.input("Launch URL - Full path or relative to http://localhost ")

  local leadingChar = string.sub(launchUrl, 1, 1)

  if leadingChar == "/" or leadingChar == ":" then
    launchUrl = "http://localhost" .. launchUrl
  end

  local sourcemapKeys = {"/./*", "/src/*", "webpack:///./*"}
  local webrootMapPath = "${webRoot}/*"
  local sourceMapOverrides = {}
  -- sourceMapOverrides[sourcemapKeys[1]] = webrootMapPath
  -- sourceMapOverrides[sourcemapKeys[2]] = webrootMapPath
  -- sourceMapOverrides[sourcemapKeys[3]] = webrootMapPath
  -- "/*": "*",
  -- "/./~/*": "${webRoot}/node_modules/*"
  dap.set_log_level("TRACE")
  dap.run(
    {
      type = "chrome",
      request = "launch",
      stopOnEntry = true,
      url = launchUrl,
      webRoot = "${workspaceFolder}/src",
      runtimeExecutable = "/usr/bin/google-chrome",
      -- sourceMapPathOverrides = sourceMapOverrides
    }
  )
end

local function launchNetCoreDbg()
  -- dap.set_log_level("TRACE")

  dap.run(
    {
      type = "netcoredbg",
      name = "attach - netcoredbg",
      request = "attach",
      processId = function()
        -- TODO: Select a project and launchsettings to run with then dotnet run and attach to that PID
        return dapUtils.pick_process()
      end
      -- program = function()
      --   return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
      -- end,
    }
  )
end

local function launchBashDebug()
  dap.run(
    {
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
      pathBashdb = {os.getenv('HOME') .. '/debug-adapters/vscode-bash-debug/bashdb_dir/bashdb'},
      pathBashdbLib = {os.getenv('HOME') .. '/debug-adapters/vscode-bash-debug/bashdb_dir'},
      terminalKind = "integrated",
      args = function()
        return vim.fn.split(vim.fn.input('Scripts args:'))
      end,
    }
  )
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
    launchNetCoreDbg()
  end
end

local function startDebugTest()
  if dap.session() then
    dap.disconnect()
    dap.close()
  end

  if vim.bo.filetype == "typescript" or vim.bo.filetype == "typescriptreact" then
    -- TODO: Use the 'jester' plugin to debug jest test here
  elseif vim.bo.filetype == "cs" then
  -- TODO: Run dotnet test with env variable set to wait for debug attachment. Get PID and attach
  end
end

return {
  startDebugAttach = startDebugAttach,
  startDebugLaunch = startDebugLaunch,
  startDebugTest = startDebugTest
}
