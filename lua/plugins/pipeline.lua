vim.pack.add({
  { src = "https://github.com/topaxi/pipeline.nvim" },
})

vim.keymap.set("n", "<leader>gh", "<cmd>Pipeline<cr>", { desc = "Open Pipeline" })

require("pipeline").setup({
  browser = "wsl-open",
})
