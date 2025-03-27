return {
  {
    "Issafalcon/neosharper.nvim",
    ft = { "cs" },
    event = "BufReadPre",
    config = function()
      require("neosharper").setup()
    end,
  },
}
