vim.pack.add({
  { src = "https://github.com/mbbill/undotree" },
})

vim.keymap.set("n", "<A-u>", ":UndotreeToggle<CR>", { desc = "Undotree: Toggle undotree" })
