local notify_keys = {
  {
    "n",
    "<leader>nd",
    function()
      require("notify").dismiss({ silent = true, pending = true })
    end,
    { desc = "Dismiss all notifications" },
  },
}

-- https://github.com/rcarriga/nvim-notify
local notify_plugin = require("notify")
notify_plugin.setup({
  stages = "fade_in_slide_out",
  background_colour = "#000000",
  max_height = function()
    return math.floor(vim.o.lines * 0.75)
  end,
  max_width = function()
    return math.floor(vim.o.columns * 0.75)
  end,
})

vim.notify = notify_plugin

fignvim.mappings.create_keymaps(notify_keys)
