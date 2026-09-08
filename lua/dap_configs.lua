local M = {}

local install_dir = fignvim.path.concat({ vim.fn.stdpath("data"), "mason" })

M.javascript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch Node File",
    program = "${file}",
    cwd = "${workspaceFolder}",
  },
  {
    -- use nvim-dap-vscode-js's pwa-node debug adapter
    type = "pwa-node",
    -- attach to an already running node process with --inspect flag
    -- default port: 9222
    request = "attach",
    -- allows us to pick the process using a picker
    processId = require("dap.utils").pick_process,
    -- name of the debug action you have to select for this config
    name = "Attach debugger to existing `node --inspect` process",
    -- for compiled languages like TypeScript or Svelte.js
    sourceMaps = true,
    -- resolve source maps in nested locations while ignoring node_modules
    resolveSourceMapLocations = {
      "${workspaceFolder}/**",
      "!**/node_modules/**",
    },
    -- path to src in vite based projects (and most other projects as well)
    cwd = "${workspaceFolder}/src",
    -- we don't want to debug code inside node_modules, so skip it!
    skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
  },
  {
    type = "pwa-chrome",
    name = "Launch Chrome to debug client",
    request = "launch",
    url = function()
      local port = vim.fn.input("Select application port: ", 5173) -- Default vite / remix port
      return "http://localhost:" .. port
    end,
    sourceMaps = true,
    protocol = "inspector",
    port = 9222,
    -- This may need updating depending on the framework source dir
    webRoot = "${workspaceFolder}",
    -- skip files from vite's hmr
    skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" },
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
  -- This needs tweaking for WSL and Brave
  -- See https://stackoverflow.com/questions/53380075/how-to-attach-the-vscode-debugger-to-the-brave-browser
  {
    type = "pwa-chrome",
    request = "attach",
    name = "Attach to Chrome",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    hostName = "127.0.0.1",
    urlFilter = "http://localhost:5173/*",
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
    file = "${file}",
    request = "launch",
    env = {},
    cwd = "${workspaceFolder}",
    pathBash = "bash",
    pathCat = "cat",
    pathMkfifo = "mkfifo",
    pathPkill = "pkill",
    pathBashdb = {
      install_dir .. "/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
    },
    pathBashdbLib = { install_dir .. "/packages/bash-debug-adapter/extension/bashdb_dir" },
    terminalKind = "integrated",
    args = function()
      return vim.fn.split(vim.fn.input("Scripts args:"))
    end,
  },
}

M.cs = {
  {
    type = "netcoredbg",
    justMyCode = false,
    enableStepFiltering = false,
    stopAtEntry = false,
    name = "attach - netcoredbg",
    request = "attach",
    processId = require("dap.utils").pick_process,
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
