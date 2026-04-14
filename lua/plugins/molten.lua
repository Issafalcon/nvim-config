vim.pack.add({
  {
    src = "https://github.com/benlubas/molten-nvim",
    version = "v1.9.2",
  },
})

vim.g.molten_image_provider = "image.nvim"
vim.g.molten_auto_open_output = true
vim.g.molten_auto_open_html_in_browser = true
vim.g.molten_tick_rate = 200

-- MoltenInit: when a kernel is active, the smart send_cell in slime.lua
-- will automatically route <c-cr> / <leader><cr> through QuartoSend (molten).
-- MoltenDeinit: reverts routing back to vim-slime automatically.
vim.keymap.set("n", "<localleader>mi", "<cmd>MoltenInit<cr>", { silent = true, desc = "[i]nitialize molten" })
vim.keymap.set("n", "<localleader>md", "<cmd>MoltenDeinit<cr>", { silent = true, desc = "[d]einit molten" })
vim.keymap.set("n", "<localleader>mp", ":MoltenImagePopup<CR>", { silent = true, desc = "image [p]opup" })
vim.keymap.set("n", "<localleader>mb", ":MoltenOpenInBrowser<CR>", { silent = true, desc = "open in [b]rowser" })
vim.keymap.set("n", "<localleader>mh", ":MoltenHideOutput<CR>", { silent = true, desc = "[h]ide output" })
vim.keymap.set(
  "n",
  "<localleader>ms",
  ":noautocmd MoltenEnterOutput<CR>",
  { silent = true, desc = "[s]how/enter output" }
)
vim.keymap.set("n", "<localleader>mr", ":MoltenReevaluateCell<CR>", { silent = true, desc = "[r]e-evaluate cell" })
vim.keymap.set("n", "<localleader>mR", ":MoltenRestart!<CR>", { silent = true, desc = "[R]estart kernel" })
