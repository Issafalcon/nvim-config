vim.pack.add({
  { src = "https://github.com/akinsho/toggleterm.nvim" },
})

require("toggleterm").setup({
  size = 10,
  open_mapping = [[<F7><F7>]],
  shading_factor = 2,
  direction = "float",
  float_opts = {
    border = "curved",
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
})

vim.keymap.set("n", "<F7>n", function()
  fignvim.term.toggle_term_cmd("node")
end, { desc = "ToggleTerm with Node" })

vim.keymap.set("n", "<F7>d", function()
  fignvim.term.toggle_term_cmd("lazydotnet") -- https://github.com/ckob/lazydotnet
end, { desc = "ToggleTerm with LazyDotnet" })

vim.keymap.set("n", "<F7>p", function()
  fignvim.term.toggle_term_cmd("python3")
end, { desc = "ToggleTerm with Python" })

vim.keymap.set("n", "<F7>f", "<cmd>ToggleTerm direction=float<cr>", { desc = "ToggleTerm in floating window" })
vim.keymap.set(
  "n",
  "<F7>h",
  "<cmd>ToggleTerm size=10 direction=horizontal<cr>",
  { desc = "ToggleTerm in horizontal split" }
)
vim.keymap.set(
  "n",
  "<F7>v",
  "<cmd>ToggleTerm size=80 direction=vertical<cr>",
  { desc = "ToggleTerm in vertical split" }
)
vim.keymap.set({ "n", "t" }, "<F7><F7>", "<cmd>ToggleTerm<cr>", { desc = "ToggleTerm" })
vim.keymap.set({ "n", "t" }, "<C-'>", "<cmd>ToggleTerm<cr>", { desc = "ToggleTerm" })
