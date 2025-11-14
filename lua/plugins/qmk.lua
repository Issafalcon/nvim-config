vim.pack.add({
  { src = "https://github.com/codethread/qmk.nvim" },
})

require("qmk").setup({
  name = "LAYOUT_split_4x6_5",
  layout = {
    "x x x x x x _ _ _ _ _ x x x x x x",
    "x x x x x x _ _ _ _ _ x x x x x x",
    "x x x x x x _ _ _ _ _ x x x x x x",
    "x x x x x x x _ _ _ x x x x x x x",
    "_ _ _ x x x x x _ x x x x x _ _ _",
  },
})
