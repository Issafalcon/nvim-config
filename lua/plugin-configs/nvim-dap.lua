local dap = fignvim.plug.load_module_file("dap")
if not dap then
  return
end

local install_dir = fignvim.path.concat({ vim.fn.stdpath("data"), "mason" })
-- Settings
dap.defaults.fallback.terminal_win_cmd = "80vsplit new"
vim.fn.sign_define("DapBreakpoint", { text = "👊", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "✋", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "👉", texthl = "", linehl = "", numhl = "" })

-- Enable autocompletion in dap-repl
vim.cmd([[
  augroup dap_config
    autocmd!
    autocmd FileType dap-repl lua require('dap.ext.autocompl').attach()
  augroup end
]])

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
