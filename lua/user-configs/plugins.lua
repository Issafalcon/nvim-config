M = {}

M.plugins = {
  -- Plugin manager
  ["wbthomason/packer.nvim"] = {},

  -- Optimiser
  ["lewis6991/impatient.nvim"] = {},

  -- Lua functions
  ["nvim-lua/plenary.nvim"] = { module = "plenary" },

  -- Notification Enhancer
  ["rcarriga/nvim-notify"] = {
    event = "UIEnter",
    config = function()
      require("plugin-configs.notify")
    end,
  },
}
return M
