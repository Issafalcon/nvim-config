vim.pack.add({
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/jbyuki/one-small-step-for-vimkind" },
  { src = "https://github.com/rcarriga/nvim-dap-ui" },
  { src = "https://github.com/mxsdev/nvim-dap-vscode-js" },
  { src = "https://github.com/Weissle/persistent-breakpoints.nvim" },
  { src = "https://github.com/mfussenegger/nvim-dap-python" },
  { src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
})

vim.g.dap_install_dir = fignvim.path.concat({ vim.fn.stdpath("data"), "mason" })

local dap = require("dap")

-- Settings
dap.defaults.fallback.terminal_win_cmd = "80vsplit new"

-- dap.set_log_level("TRACE") -- Verbose logging
local icons = require("icons").debug
vim.fn.sign_define("DapBreakpoint", { text = icons.Breakpoint, texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = icons.BreakpointRejected, texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = icons.Stopped, texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = icons.LogPoint, texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = icons.BreakpointCondition, texthl = "", linehl = "", numhl = "" })

-- Adapters
local netcoredbg_install_dir

if vim.fn.has("win32") == 1 then
  netcoredbg_install_dir = vim.g.dap_install_dir .. "/packages/netcoredbg/netcoredbg/netcoredbg.exe"
else
  netcoredbg_install_dir = vim.g.dap_install_dir .. "/packages/netcoredbg/netcoredbg"
end

dap.adapters.netcoredbg = {
  type = "executable",
  command = netcoredbg_install_dir,
  args = { "--interpreter=vscode" },
}

dap.adapters.bashdb = {
  type = "executable",
  command = vim.g.dap_install_dir .. "/packages/bash-debug-adapter/bash-debug-adapter",
  name = "bashdb",
}

dap.adapters.nlua = function(callback, config)
  callback({
    type = "server",
    host = config.host or "127.0.0.1",
    port = config.port or 8086,
  })
end

-- Can't get this to work on WSL currently, but seems to be the best best to try
require("dap-vscode-js").setup({
  debugger_path = vim.g.dap_install_dir .. "/packages/js-debug-adapter",
  log_console_level = vim.log.levels.INFO,
  adapters = {
    "chrome",
    "pwa-node",
    "pwa-chrome",
    "pwa-msedge",
    "node-terminal",
    "pwa-extensionHost",
  },
})

fignvim.debugging.setup_debug_configs()

require("nvim-dap-virtual-text").setup({
  enabled = true, -- enable this plugin (the default)
  enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
  highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
  highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
  show_stop_reason = true, -- show stop reason when stopped for exceptions
  commented = false, -- prefix virtual text with comment string

  -- experimental features:
  virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
  all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
  virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
  virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
  -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
})

require("persistent-breakpoints").setup({
  save_dir = vim.fn.stdpath("data") .. "/nvim_checkpoints",
  -- when to load the breakpoints? "BufReadPost" is recommanded.
  load_breakpoints_event = { "BufReadPost" },
  -- record the performance of different function. run :lua require('persistent-breakpoints.api').print_perf_data() to see the result.
  perf_record = false,
  -- perform callback when loading a persisted breakpoint
  on_load_breakpoint = nil,
})

local dapui = require("dapui")

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close("tray")
  dap.repl.close()
  dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close("tray")
  dap.repl.close()
  dapui.close()
end

dapui.setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
  },
  controls = {
    enabled = true,
    element = "repl",
    icons = {
      pause = "",
      play = "契",
      step_into = "",
      step_over = "",
      step_out = "",
      step_back = "倫",
      run_last = "",
      terminate = "",
    },
  },
  layouts = {
    {
      elements = {
        "scopes",
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40,
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 10,
      position = "bottom",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
})

local path = vim.g.dap_install_dir .. "/packages/debugpy/venv/bin/python"

require("dap-python").setup(path)

-- Keymaps

vim.keymap.set("n", "<F5>", ':lua require"osv".launch({port=8086})<CR>', { desc = "Launch OSV server" })
vim.keymap.set("n", "<F9>", ':lua require"dap".continue()<CR>', { desc = "DAP Continue" })
vim.keymap.set(
  "n",
  "<leader>db",
  '<cmd>lua require("persistent-breakpoints.api").toggle_breakpoint()<cr>',
  { desc = "DAP Toggle Breakpoint" }
)
vim.keymap.set(
  "n",
  "<leader>dB",
  '<cmd>lua require("persistent-breakpoints.api").set_conditional_breakpoint()<cr>',
  { desc = "DAP Toggle Conditional Breakpoint" }
)
vim.keymap.set(
  "n",
  "<leader>de",
  ':lua require"dap".set_exception_breakpoints()<CR>',
  { desc = "DAP Set breakpoints on exceptions" }
)
vim.keymap.set(
  "n",
  "<leader>dbc",
  '<cmd>lua require("persistent-breakpoints.api").clear_all_breakpoints()<cr>',
  { desc = "DAP Clear all breakpoints on exceptions" }
)
vim.keymap.set("n", "<leader>dk", ':lua require"dap".step_out()<CR>', { desc = "DAP Step Out" })
vim.keymap.set("n", "<leader>dj", ':lua require"dap".step_into()<CR>', { desc = "DAP Step Into" })
vim.keymap.set("n", "<leader>dl", ':lua require"dap".step_over()<CR>', { desc = "DAP Step Over" })
vim.keymap.set(
  "n",
  "<leader>dp",
  ':lua require"dap".up()<CR>',
  { desc = "DAP Go up in current stacktrace without stepping" }
)
vim.keymap.set(
  "n",
  "<leader>dn",
  ':lua require"dap".down()<CR>',
  { desc = "DAP Go down in current stacktrace without stepping" }
)
vim.keymap.set(
  "n",
  "<leader>dc",
  ':lua require"dap".disconnect();require"dap".close();require"dapui".close()<CR>',
  { desc = "DAP Disconnect and close nvim-dap and dap-ui. Doesn't kill the debugee" }
)
vim.keymap.set(
  "n",
  "<leader>dC",
  ':lua require"dap".terminate();require"dap".close()<CR>',
  { desc = "DAP Terminates the debug session}, also killing the debugee" }
)
vim.keymap.set("n", "<F12>", ':lua require"dap.ui.widgets".hover()<CR>', { desc = "DAP Hover info for variables" })
vim.keymap.set(
  "n",
  "<leader>d?",
  ':lua local widgets = require"dap.ui.widgets";widgets.centered_float(widgets.scopes)<CR>',
  { desc = "DAP Show scopes in sidebar" }
)
vim.keymap.set(
  "n",
  "<leader>dr",
  ':lua require"dap".repl.open({}, "vsplit")<CR><C-w>l',
  { desc = "DAP Opens repl in vsplit" }
)
