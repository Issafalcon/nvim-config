return {
  {
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
  },
}
