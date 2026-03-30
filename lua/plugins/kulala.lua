vim.pack.add({
  {
    src = "https://github.com/mistweaverco/kulala.nvim",
  },
})

vim.filetype.add({
  extension = {
    ["http"] = "http",
  },
})

require("kulala").setup({
  global_keymaps = true,
  global_keymaps_prefix = "<leader>k",
  kulala_keymaps_prefix = "",
})
