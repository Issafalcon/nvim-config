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
local init = function()
  QuartoConfig.codeRunner.default_method = "molten"
  vim.cmd([[MoltenInit]])
end
local deinit = function()
  QuartoConfig.codeRunner.default_method = "slime"
  vim.cmd([[MoltenDeinit]])
end

vim.keymap.set("n", "<localleader>mi", init, { silent = true, desc = "Initialize molten" })
vim.keymap.set("n", "<localleader>md", deinit, { silent = true, desc = "Stop molten" })
vim.keymap.set("n", "<localleader>mp", ":MoltenImagePopup<CR>", { silent = true, desc = "molten image popup" })
vim.keymap.set("n", "<localleader>mb", ":MoltenOpenInBrowser<CR>", { silent = true, desc = "molten open in browser" })
vim.keymap.set("n", "<localleader>mh", ":MoltenHideOutput<CR>", { silent = true, desc = "hide output" })
vim.keymap.set(
  "n",
  "<localleader>ms",
  ":noautocmd MoltenEnterOutput<CR>",
  { silent = true, desc = "show/enter output" }
)
