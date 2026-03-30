vim.pack.add({
  { src = "https://github.com/Equilibris/nx.nvim" },
})

require("nx").setup({
  -- See below for config options
  nx_cmd_root = "nx",
})

vim.keymap.set("n", "<leader>nx", "<cmd>Telescope nx actions<CR>", { desc = "Brings up Nx command pallete" })
