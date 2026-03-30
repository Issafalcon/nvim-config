vim.pack.add({
  {
    src = "https://github.com/ThePrimeagen/harpoon",
  },
})

require("harpoon").setup({
  menu = {
    width = vim.api.nvim_win_get_width(0) - 4,
  },
})

vim.keymap.set("n", "<leader>hh", function()
  require("harpoon.ui").toggle_quick_menu()
end, { desc = "Harpoon: Toggle Quick Menu" })

vim.keymap.set("n", "<leader>ha", function()
  require("harpoon.mark").add_file()
end, { desc = "Harpoon: Add File" })

for i = 1, 8 do
  vim.keymap.set("n", "<leader>" .. i, function()
    require("harpoon.ui").nav_file(i)
  end, { desc = "Harpoon: Navigate to file " .. i })
end
