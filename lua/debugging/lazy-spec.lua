local dap_keys = require("keymaps").Debugging
local dap_config = require("debugging.plugin-config.dap")
local dap_python_config = require("debugging.plugin-config.dap-python")
local persistent_breakpoints_config = require("debugging.plugin-config.persistent-breakpoints")
local dap_ui_config = require("debugging.plugin-config.dap-ui")
local dap_virtual_text_config = require("debugging.plugin-config.dap-virtual-text")

return {
  {
    "mfussenegger/nvim-dap",
    keys = fignvim.mappings.make_lazy_keymaps(dap_keys, true),
    dependencies = {
      "mason.nvim",
      "jbyuki/one-small-step-for-vimkind",
      "rcarriga/nvim-dap-ui",
      "mxsdev/nvim-dap-vscode-js",
      {
        "microsoft/vscode-js-debug",
        version = "1.x",
        build = "npm i && npm run compile vsDebugServerBundle && mv dist out",
      },
      {
        "Weissle/persistent-breakpoints.nvim",
        event = "BufReadPre",
        opts = persistent_breakpoints_config.lazy_opts,
      },
    },
    config = dap_config.lazy_config,
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = { "python" },
    config = dap_python_config.lazy_config,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "nvim-neotest/nvim-nio",
    },
    opts = dap_ui_config.lazy_opts,
    config = dap_ui_config.lazy_config,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = dap_virtual_text_config.lazy_opts,
  },
}
