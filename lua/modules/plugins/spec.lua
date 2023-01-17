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

local spec = fignvim.module.enable_registered_plugins({
  ["sqlite"] = sqlite_spec,
  ["neodev"] = neodev_spec,
  ["luapad"] = luapad_spec,
}, "plugins")

table.insert(spec, { "nvim-lua/plenary.nvim" })

return spec