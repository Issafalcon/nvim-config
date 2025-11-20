vim.pack.add({
  { src = "https://github.com/Wansmer/treesj" },
})

require("treesj").setup({
  use_default_keymaps = false,
  max_join_length = 140,
})

vim.keymap.set("n", "<leader>j", "<cmd>TSJToggle<cr>", { desc = "Join Toggle" })
