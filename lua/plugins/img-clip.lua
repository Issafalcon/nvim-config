vim.pack.add({
  {
    src = "https://github.com/HakonHarnes/img-clip.nvim",
  },
})

require("img-clip").setup({
  default = {
    dir_path = "img",
    drag_and_drop = {
      enabled = false,
      insert_mode = false,
    },
  },
  filetypes = {
    markdown = {
      url_encode_path = true,
      template = "![$CURSOR]($FILE_PATH)",
      drag_and_drop = {
        download_images = false,
      },
    },
    quarto = {
      url_encode_path = true,
      template = "![$CURSOR]($FILE_PATH)",
      drag_and_drop = {
        download_images = false,
      },
    },
  },
})

vim.keymap.set("n", "<leader>ii", ":PasteImage<cr>", { desc = "insert [i]mage from clipboard" })
