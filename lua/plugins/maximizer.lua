vim.pack.add({
  { src = "https://github.com/szw/vim-maximizer" },
})

vim.keymap.set("n", "<leader>mm", ":MaximizerToggle!<CR>", { desc = "Toggle maximizer (current window)" })
