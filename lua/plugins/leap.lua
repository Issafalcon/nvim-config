vim.pack.add({
  { src = "https://github.com/ggandor/leap.nvim" },
})

vim.keymap.set("n", "<C-m>", "<plug>(leap-forward)", { desc = "Leap: Forward to" })
vim.keymap.set("n", "<C-n>", "<plug>(leap-backward)", { desc = "Leap: Backward to" })
vim.keymap.set("n", "gs", "<plug>(leap-anywhere)", { desc = "Leap: Across all windows" })
