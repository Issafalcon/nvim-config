local dap_keys = {
  {
    "n",
    "<F5>",
    ':lua require"osv".launch({port=8086})<CR>',
    { desc = "DAP Continue" },
  },
  {
    "n",
    "<F9>",
    ':lua require"dap".continue()<CR>',
    { desc = "DAP Continue" },
  },
  {
    "n",
    "<leader>db",
    ':lua require"dap".toggle_breakpoint()<CR>',
    { desc = "DAP Toggle Breakpoint" },
  },
  {
    "n",
    "<leader>dB",
    ':lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',
    { desc = "DAP Toggle Conditional Breakpoint" },
  },
  {
    "n",
    "<leader>de",
    ':lua require"dap".set_exception_breakpoints()<CR>',
    { desc = "DAP Set breakpoints on exceptions" },
  },
  {
    "n",
    "<leader>dbc",
    ':lua require"dap".clear_breakpoints()<CR>',
    { desc = "DAP Clear all breakpoints on exceptions" },
  },
  {
    "n",
    "<leader>dk",
    ':lua require"dap".step_out()<CR>',
    { desc = "DAP Step Out" },
  },
  {
    "n",
    "<leader>dj",
    ':lua require"dap".step_into()<CR>',
    { desc = "DAP Step Into" },
  },
  {
    "n",
    "<leader>dl",
    ':lua require"dap".step_over()<CR>',
    { desc = "DAP Step Over" },
  },
  {
    "n",
    "<leader>dp",
    ':lua require"dap".up()<CR>',
    { desc = "DAP Go up in current stacktrace without stepping" },
  },
  {
    "n",
    "<leader>dn",
    ':lua require"dap".down()<CR>',
    { desc = "DAP Go down in current stacktrace without stepping" },
  },
  {
    "n",
    "<leader>dc",
    ':lua require"dap".disconnect();require"dap".close();require"dapui".close()<CR>',
    { desc = "DAP Disconnect and close nvim-dap and dap-ui. Doesn't kill the debugee" },
  },
  {
    "n",
    "<leader>dC",
    ':lua require"dap".terminate();require"dap".close()<CR>',
    { desc = "DAP Terminates the debug session}, also killing the debugee" },
  },
  {
    "n",
    "<F12>",
    ':lua require"dap.ui.widgets".hover()<CR>',
    { desc = "DAP Hover info for variables" },
  },
  {
    "n",
    "<leader>d?",
    ':lua local widgets = require"dap.ui.widgets";widgets.centered_float(widgets.scopes)<CR>',
    { desc = "DAP Show scopes in sidebar" },
  },
  {
    "n",
    "<leader>dr",
    ':lua require"dap".repl.open({}, "vsplit")<CR><C-w>l',
    { desc = "DAP Opens repl in vsplit" },
  },
}

local dap_spec = {
  {
    "mfussenegger/nvim-dap",
    keys = fignvim.mappings.make_lazy_keymaps(dap_keys, true),
    dependencies = {
      "mason.nvim",
      "jbyuki/one-small-step-for-vimkind",
    },
    config = function()
      local dap = require("dap")
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

      local netcoredbg_install_dir = vim.fn.has("win32") and install_dir .. "/packages/netcoredbg/netcoredbg/netcoredbg.exe"
        or install_dir .. "/packages/netcoredbg/netcoredbg/netcoredbg"

      dap.adapters.netcoredbg = {
        type = "executable",
        command = netcoredbg_install_dir,
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

      fignvim.mappings.register_keymap_group("Debug", dap_keys, false)

      fignvim.debug.setup_debug_configs()
    end,
  },
}

local dap_ui_spec = {
  "rcarriga/nvim-dap-ui",
  opts = {
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
  },
  config = function(_, opts)
    local dap = require("dap")
    local dapui = require("dapui")

    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end

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

    dapui.setup(opts)
  end,
}

local dap_virtual_text_spec = {
  "theHamsta/nvim-dap-virtual-text",
  opts = {
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
  },
}

local dap_vscode_js_spec = {
  "mxsdev/nvim-dap-vscode-js",
  config = function()
    local dap_vscode = require("dap-vscode-js")
    local install_dir = fignvim.path.concat({ vim.fn.stdpath("data"), "mason" })

    dap_vscode.setup({
      adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
      debugger_path = install_dir .. "/packages/js-debug-adapter",
      -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
      log_file_level = 1, -- Logging level for output to file. Set to false to disable file logging.
      -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
    })
  end,
}

return fignvim.module.enable_registered_plugins({
  ["dap"] = dap_spec,
  ["dap-ui"] = dap_ui_spec,
  ["dap-virtual-text"] = dap_virtual_text_spec,
  ["dap-vscode-js"] = dap_vscode_js_spec,
}, "debugging")
