local M = {}

local install_dir = fignvim.path.concat({ vim.fn.stdpath("data"), "mason" })

-- Helper functions for .NET taken from https://github.com/mfussenegger/nvim-dap/wiki/Cookbook#making-debugging-net-easier
vim.g.dotnet_build_project = function()
  local default_path = vim.fn.getcwd() .. "/"
  if vim.g["dotnet_last_proj_path"] ~= nil then default_path = vim.g["dotnet_last_proj_path"] end
  local path = vim.fn.input("Path to your *proj file", default_path, "file")
  vim.g["dotnet_last_proj_path"] = path
  local cmd = "dotnet build -c Debug " .. path .. " > /dev/null"
  print("")
  print("Cmd to execute: " .. cmd)
  local f = os.execute(cmd)
  if f == 0 then
    print("\nBuild: ✔️ ")
  else
    print("\nBuild: ❌ (code: " .. f .. ")")
  end
end

vim.g.dotnet_get_dll_path = function()
  local request = function()
    local label_fn = function(dll) return string.format("dll = %s", dll.short_path) end
    local procs = {}
    for _, csprojPath in ipairs(vim.fn.glob(vim.fn.getcwd() .. "**/*.csproj", false, true)) do
      local name = vim.fn.fnamemodify(csprojPath, ":t:r")
      for _, path in ipairs(vim.fn.glob(vim.fn.getcwd() .. "**/bin/**/" .. name .. ".dll", false, true)) do
        table.insert(procs, {
          path = path,
          short_path = vim.fn.fnamemodify(path, ":p:."),
        })
      end
    end

    local co, ismain = coroutine.running()
    local ui = require("dap.ui")
    local pick = (co and not ismain) and ui.pick_one or ui.pick_one_sync
    local result = pick(procs, "Select process: ", label_fn)
    return result and result.path or require("dap").ABORT
  end

  if vim.g["dotnet_last_dll_path"] == nil then
    vim.g["dotnet_last_dll_path"] = request()
  else
    if vim.fn.confirm("Do you want to change the path to dll?\n" .. vim.g["dotnet_last_dll_path"], "&yes\n&no", 2) == 1 then
      vim.g["dotnet_last_dll_path"] = request()
    end
  end

  return vim.g["dotnet_last_dll_path"]
end

M.javascript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch Node File",
    program = "${file}",
    cwd = "${workspaceFolder}",
  },
  {
    type = "pwa-node",
    request = "attach",
    name = "Attach to Node Process",
    processId = require("dap.utils").pick_process,
    cwd = "${workspaceFolder}",
  },
  {
    type = "pwa-node",
    request = "launch",
    name = "Debug Mocha Tests",
    -- trace = true, -- include debugger info
    runtimeExecutable = "node",
    runtimeArgs = {
      "./node_modules/mocha/bin/mocha.js",
    },
    rootPath = "${workspaceFolder}",
    cwd = "${workspaceFolder}",
    console = "integratedTerminal",
    internalConsoleOptions = "neverOpen",
  },
  {
    type = "pwa-chrome",
    request = "launch",
    name = "Launch Chrome",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    hostName = "127.0.0.1",
    port = 9222,
    webRoot = "${workspaceFolder}",
  },
  {
    type = "pwa-chrome",
    request = "attach",
    name = "Attach to Chrome",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    hostName = "127.0.0.1",
    port = 9222,
    webRoot = "${workspaceFolder}",
  },
}

M.typescript = M.javascript
M.javascriptreact = M.javascript
M.typescriptreact = M.javascript

M.sh = {
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
    pathBashdb = { install_dir .. "/packages/bash-debug-adapter/extension/bashdb_dir/bashdb" },
    pathBashdbLib = { install_dir .. "/packages/bash-debug-adapter/extension/bashdb_dir" },
    terminalKind = "integrated",
    args = function() return vim.fn.split(vim.fn.input("Scripts args:")) end,
  },
}

M.cs = {
  {
    type = "netcoredbg",
    name = "attach - netcoredbg",
    request = "attach",
    processId = require("dap.utils").pick_process,
  },
  {
    type = "netcoredbg",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
      if vim.fn.confirm("Should I recompile first?", "&yes\n&no", 2) == 1 then vim.g.dotnet_build_project() end
      return vim.g.dotnet_get_dll_path()
    end,
  },
}

M.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance",
  },
}

return M
