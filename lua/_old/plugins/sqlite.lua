-- Persistent storage for some plugins
return {
  {
    "kkharji/sqlite.lua",
    enabled = function() return not jit.os:find("Windows") end,
  },
}
