vim.pack.add({
  { src = "https://github.com/sudormrfbin/cheatsheet.nvim" },
})

require("cheatsheet").setup()

vim.keymap.set("n", "<leader>?", ":Cheatsheet<CR>", { desc = "Toggles Cheatsheet help window in Telescope" })
