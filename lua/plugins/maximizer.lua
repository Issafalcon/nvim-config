vim.pack.add({
  { src = "https://github.com/szw/vim-maximizer" },
})

vim.keymap.set("n", "<leader>m", ":MaximizerToggle!<CR>", { desc = "Toggle maximizer (current window)" })
