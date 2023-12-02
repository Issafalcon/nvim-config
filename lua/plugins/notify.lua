local notify_keys = {
  {
    "n",
    "<leader>nd",
    function() require("notify").dismiss({ silent = true, pending = true }) end,
    { desc = "Dismiss all notifications" },
  },
}

return {
  {
    "rcarriga/nvim-notify",
    event = "UIEnter",
    keys = fignvim.mappings.make_lazy_keymaps(notify_keys, true),
    opts = {
      stages = "fade_in_slide_out",
      background_colour = "#000000",
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width = function() return math.floor(vim.o.columns * 0.75) end,
    },
    config = function(_, opts)
      local notify_plugin = require("notify")
      notify_plugin.setup(opts)
      vim.notify = notify_plugin
    end,
  },
}
