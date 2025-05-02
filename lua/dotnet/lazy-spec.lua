return {
  {
    "seblj/roslyn.nvim",
    event = "BufReadPre",
  },
  -- lazy.nvim
  {
    "bosvik/roslyn-diagnostics.nvim",
    -- lazy load on filetype
    ft = { "cs", "fs" },
    opts = {},
  },
}
