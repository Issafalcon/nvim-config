local sqlite_spec = {
  "kkharji/sqlite.lua",
  enabled = function() return not jit.os:find("Windows") end,
}

return {
  sqlite_spec,
}
