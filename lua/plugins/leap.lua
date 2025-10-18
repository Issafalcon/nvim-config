vim.pack.add({
  { src = "https://github.com/ggandor/leap.nvim" },
})

vim.keymap.set("n", "<C-m>", "<plug>(leap-forward-to)", { desc = "Leap: Forward to" })
vim.keymap.set("n", "<C-n>", "<plug>(leap-backward-to)", { desc = "Leap: Backward to" })
vim.keymap.set("n", "gs", "<plug>(leap-cross-window)", { desc = "Leap: Across all windows" })
