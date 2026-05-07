vim.pack.add({
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
})

require("render-markdown").setup({
  file_types = { "markdown", "codecompanion" },
})
