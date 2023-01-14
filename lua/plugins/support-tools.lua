-- Persistent storage for some plugins
local sqlite_spec = {
  "kkharji/sqlite.lua",
  enabled = function() return not jit.os:find("Windows") end,
}

local neodev_spec = {
  "folke/neodev.nvim",
  event = "VeryLazy",
}

local luapad_spec = {
  "rafcamlet/nvim-luapad",
  event = "VeryLazy",
}
return {
  sqlite_spec,
  neodev_spec,
  luapad_spec,

  -- Lib used by other plugins
  "nvim-lua/plenary.nvim",
}
