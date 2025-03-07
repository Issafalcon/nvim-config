local dap_keys = {
  {
    "n",
    "<F5>",
    ':lua require"osv".launch({port=8086})<CR>',
    { desc = "Launch OSV server" },
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
    '<cmd>lua require("persistent-breakpoints.api").toggle_breakpoint()<cr>',
    { desc = "DAP Toggle Breakpoint" },
  },
  {
    "n",
    "<leader>dB",
    '<cmd>lua require("persistent-breakpoints.api").set_conditional_breakpoint()<cr>',
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
    '<cmd>lua require("persistent-breakpoints.api").clear_all_breakpoints()<cr>',
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

local install_dir = fignvim.path.concat({ vim.fn.stdpath("data"), "mason" })

return {
  {
    {
      "mfussenegger/nvim-dap",
      keys = fignvim.mappings.make_lazy_keymaps(dap_keys, true),
      dependencies = {
        "mason.nvim",
        "jbyuki/one-small-step-for-vimkind",
        "rcarriga/nvim-dap-ui",
        "mxsdev/nvim-dap-vscode-js",
        -- build debugger from source
        {
          "microsoft/vscode-js-debug",
          version = "1.x",
          build = "npm i && npm run compile vsDebugServerBundle && mv dist out",
        },
        {
          "Weissle/persistent-breakpoints.nvim",
          event = "BufReadPre",
          opts = {
            save_dir = vim.fn.stdpath("data") .. "/nvim_checkpoints",
            -- when to load the breakpoints? "BufReadPost" is recommanded.
            load_breakpoints_event = { "BufReadPost" },
            -- record the performance of different function. run :lua require('persistent-breakpoints.api').print_perf_data() to see the result.
            perf_record = false,
            -- perform callback when loading a persisted breakpoint
            on_load_breakpoint = nil,
          },
        },
      },
      config = function()
        local dap = require("dap")

        -- Settings
        dap.defaults.fallback.terminal_win_cmd = "80vsplit new"

        -- dap.set_log_level("TRACE") -- Verbose logging
        vim.fn.sign_define(
          "DapBreakpoint",
          { text = "👊", texthl = "", linehl = "", numhl = "" }
        )
        vim.fn.sign_define(
          "DapBreakpointRejected",
          { text = "✋", texthl = "", linehl = "", numhl = "" }
        )
        vim.fn.sign_define(
          "DapStopped",
          { text = "👉", texthl = "", linehl = "", numhl = "" }
        )

        -- Adapters
        local netcoredbg_install_dir

        if vim.fn.has("win32") == 1 then
          netcoredbg_install_dir = install_dir
            .. "/packages/netcoredbg/netcoredbg/netcoredbg.exe"
        else
          netcoredbg_install_dir = install_dir .. "/packages/netcoredbg/netcoredbg"
        end

        dap.adapters.netcoredbg = {
          type = "executable",
          command = netcoredbg_install_dir,
          args = { "--interpreter=vscode" },
        }

        dap.adapters.bashdb = {
          type = "executable",
          command = "node",
          args = {
            install_dir .. "/packages/bash-debug-adapter/extension/out/bashDebug.js",
          },
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
          debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
          log_console_level = vim.log.levels.TRACE,
          adapters = {
            "chrome",
            "pwa-node",
            "pwa-chrome",
            "pwa-msedge",
            "node-terminal",
            "pwa-extensionHost",
          },
        })

        fignvim.debug.setup_debug_configs()
      end,
    },
    {
      "mfussenegger/nvim-dap-python",
      ft = { "python" },
      config = function(_, opts)
        local path = install_dir .. "/packages/debugpy/venv/bin/python"
        require("dap-python").setup(path)
      end,
    },
  },
}
