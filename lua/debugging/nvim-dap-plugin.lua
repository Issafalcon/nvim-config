local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
local dap = require('dap')

-- Settings
dap.defaults.fallback.terminal_win_cmd = '80vsplit new'
vim.fn.sign_define('DapBreakpoint', {text='🟥', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointRejected', {text='🟦', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='⭐️', texthl='', linehl='', numhl=''})

-- Enable autocompletion in dap-repl
vim.cmd [[
  augroup dap_config
    autocmd!
    autocmd FileType dap-repl lua require('dap.ext.autocompl').attach()
  augroup end
]]

-- Adapters
dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = {os.getenv('HOME') .. '/debug-adapters/vscode-node-debug2/out/src/nodeDebug.js'}
}

dap.adapters.chrome = {
  type = 'executable',
  command = 'node',
  args = {os.getenv('HOME') .. '/debug-adapters/vscode-chrome-debug/out/src/chromeDebug.js'}
}

dap.adapters.netcoredbg = {
  type = 'executable',
  command = '/usr/local/netcoredbg',
  args = {'--interpreter=vscode'}
}

-- Configuration
dap.configurations.typescript = {
  {
    type = 'chrome',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    breakOnLoad = true,
    protocol = 'inspector',
    port = 9222,
    webRoot = '${workspaceFolder}/src',
  }
}

-- Mappings
keymap('n', '<leader>dd', ':lua require"dap".continue()<CR>', opts)
keymap('n', '<leader>db', ':lua require"dap".toggle_breakpoint()<CR>', opts)
keymap('n', '<leader>dB', ':lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', opts)
keymap('n', '<leader>dk', ':lua require"dap".step_out()<CR>', opts)
keymap('n', '<leader>dl', ':lua require"dap".step_into()<CR>', opts)
keymap('n', '<leader>dj', ':lua require"dap".step_over()<CR>', opts)
keymap('n', '<leader>dp', ':lua require"dap".up()<CR>', opts)
keymap('n', '<leader>dn', ':lua require"dap".down()<CR>', opts)
keymap('n', '<leader>dc', ':lua require"dap".disconnect();require"dap".close();require"dapui".close()<CR>', opts)
keymap('n', '<leader>dC', ':lua require"dap".terminate();require"dap".close()<CR>', opts)
keymap('n', '<leader>di', ':lua require"dap.ui.widgets".hover()<CR>', opts)
keymap('n', '<leader>d?', ':lua local widgets=require"dap.ui.widgets";widgets.centered_float(widgets.scopes)<CR>', opts)
keymap('n', '<leader>de', ':lua require"dap".set_exception_breakpoints({"all"})<CR>', opts)

-- Dap windows
keymap('n', '<leader>dr', ':lua require"dap".repl.open({}, "vsplit")<CR><C-w>l', opts)

-- Mapping to begin debugging for specific 'Modes'
--  dA = Debug Attach (Attach to a running process)
--  dL = Launch a process in debug
--  dT = Run a test in debug mode
keymap('n', '<leader>dT', ':lua require"debugging.dap-helper".startDebugTest()<CR>', opts)
keymap('n', '<leader>dA', ':lua require"debugging.dap-helper".startDebugAttach()<CR>', opts)
keymap('n', '<leader>dL', ':lua require"debugging.dap-helper".startDebugLaunch()<CR>', opts)
