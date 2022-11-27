local dap = fignvim.plug.load_module_file("dap")
if not dap then
  return
end

local install_dir = fignvim.path.concat({ vim.fn.stdpath("data"), "mason" })

-- Settings
dap.defaults.fallback.terminal_win_cmd = "80vsplit new"

-- dap.set_log_level("TRACE") -- Verbose logging
vim.fn.sign_define("DapBreakpoint", { text = "👊", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "✋", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "👉", texthl = "", linehl = "", numhl = "" })

-- Adapters
dap.adapters.node2 = {
  type = "executable",
  command = "node",
  args = { install_dir .. "/packages/node-debug2-adapter/out/src/nodeDebug.js" },
}

dap.adapters.chrome = {
  type = "executable",
  command = "node",
  args = { install_dir .. "/packages/chrome-debug-adapter/out/src/chromeDebug.js" },
}

dap.adapters.netcoredbg = {
  type = "executable",
  command = install_dir .. "/packages/netcoredbg/netcoredbg",
  args = { "--interpreter=vscode" },
}

dap.adapters.bashdb = {
  type = "executable",
  command = "node",
  args = { install_dir .. "/packages/bash-debug-adapter/extension/out/bashDebug.js" },
}

dap.adapters.nlua = function(callback, config)
  callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
end
