vim.pack.add({
  { src = "https://github.com/gbprod/cutlass.nvim" },
})

require("cutlass").setup({
  cut_key = "m",
  exclude = {},
  registers = {
    select = "_",
    delete = "_",
    change = "_",
  },
})
