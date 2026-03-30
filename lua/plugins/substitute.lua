vim.pack.add({
  { src = "https://github.com/tpope/vim-abolish" },
  { src = "https://github.com/gbprod/substitute.nvim" },
})

require("substitute").setup({
  range = {
    prefix = "S",
  },
})

vim.keymap.set("n", "s", function()
  require("substitute").operator()
end, { noremap = true, desc = "Substitute: substitute using operator with value in default buffer" })

vim.keymap.set("n", "ss", function()
  require("substitute").line()
end, { noremap = true, desc = "Substutute: Substutute line using with value in default buffer" })

vim.keymap.set("n", "S", function()
  require("substitute").eol()
end, { noremap = true, desc = "Substutute: Substitute to end of line using value in default buffer" })

vim.keymap.set("x", "s", function()
  require("substitute").visual()
end, { noremap = true, desc = "Substitute: Sustitute visual selection with value in defautl buffer" })

vim.keymap.set("n", "<leader>s", function()
  require("substitute.range").operator()
end, { noremap = true })

vim.keymap.set("x", "<leader>s", function()
  require("substitute.range").visual()
end, { noremap = true })

vim.keymap.set("n", "<leader>ss", function()
  require("substitute.range").word()
end, { noremap = true })

vim.keymap.set("n", "sx", function()
  require("substitute.exchange").operator()
end, { noremap = true })

vim.keymap.set("n", "sxx", function()
  require("substitute.exchange").line()
end, { noremap = true })

vim.keymap.set("x", "X", function()
  require("substitute.exchange").visual()
end, { noremap = true })

vim.keymap.set("n", "sxc", function()
  require("substitute.exchange").cancel()
end, { noremap = true })
