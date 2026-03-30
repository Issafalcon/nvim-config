vim.pack.add({
  { src = "https://github.com/mikavilpas/yazi.nvim" },
})

vim.g.loaded_netrwPlugin = 1

vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    require("yazi").setup({
      open_for_directories = false,
      open_multiple_tabs = true,
      keymaps = {
        show_help = "<f1>",
      },
    })
  end,
})

vim.keymap.set({ "n", "v" }, "-", "<cmd>Yazi<cr>", {
  desc = "Open yazi at the current file",
})

vim.keymap.set("n", "<leader>cw", "<cmd>Yazi cwd<cr>", {
  desc = "Open the file manager in nvim's working directory",
})

vim.keymap.set("n", "<c-up>", "<cmd>Yazi toggle<cr>", {
  desc = "Resume the last yazi session",
})
